print("SCRIPT STARTED")
import os
import cv2
import torch
import torch.nn as nn
import torch.optim as optim
import torchvision.transforms as transforms
import torchvision.models as models
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, confusion_matrix
import matplotlib.pyplot as plt
import seaborn as sns
from torch.utils.data import Dataset, DataLoader, random_split
import numpy as np
print("Imports completed")


# Define the custom dataset
class UlcerDataset(Dataset):
    def __init__(self, folder, transform=None):
        self.folder = folder
        self.transform = transform
        self.images = []
        self.labels = []
        self.class_to_index = {}

        for idx, class_name in enumerate(sorted(os.listdir(folder))):
            class_path = os.path.join(folder, class_name)
            if os.path.isdir(class_path):
                self.class_to_index[class_name] = idx
                for filename in os.listdir(class_path):
                    if filename.endswith((".jpg", ".jpeg", ".png")):
                        self.images.append(os.path.join(class_path, filename))
                        self.labels.append(idx)

        if len(self.images) == 0:
            raise ValueError(f"No valid images found in {folder}")

    def __len__(self):
        return len(self.images)

    def __getitem__(self, idx):
        image_path = self.images[idx]
        label = self.labels[idx]

        image = cv2.imread(image_path)
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        image = cv2.resize(image, (224, 224))

        if self.transform:
            image = self.transform(image)
        else:
            image = torch.from_numpy(image.transpose((2, 0, 1))).float() / 255.0

        return image, label

# Data transformations
data_transforms = transforms.Compose([
    transforms.ToPILImage(),
    transforms.RandomHorizontalFlip(),
    transforms.RandomRotation(10),
    transforms.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.2, hue=0.1),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])

# Dataset Loading
train_folder = "train_dataset"
val_folder = "val_dataset"  # Use split validation dataset

print("Loading datasets...")
train_dataset = UlcerDataset(train_folder, transform=data_transforms)
print(f"Train dataset loaded: {len(train_dataset)} images")
val_dataset = UlcerDataset(val_folder, transform=data_transforms)
print(f"Val dataset loaded: {len(val_dataset)} images")

# DataLoaders
train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True)
val_loader = DataLoader(val_dataset, batch_size=32)  # Validation DataLoader

# Initialize MobileNetV3-Small
model = models.mobilenet_v3_small(weights=models.MobileNet_V3_Small_Weights.IMAGENET1K_V1)
num_ftrs = model.classifier[3].in_features
model.classifier[3] = nn.Linear(num_ftrs, 6)  # 6 classes: Grade 0 to Grade 5

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model.to(device)
print(f"Using device: {device}")

# Loss Function & Optimizer
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)
scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=5, gamma=0.1)

# Training Loop with Validation
num_epochs = 3
model.train()
for epoch in range(num_epochs):
    print(f"\nStarting Epoch {epoch + 1}/{num_epochs}")
    running_loss = 0.0
    model.train()  # Ensure model is in training mode
   
    # Training Loop
    for i, (inputs, labels) in enumerate(train_loader):
        inputs, labels = inputs.to(device), labels.to(device)
        optimizer.zero_grad()
        outputs = model(inputs)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()
        running_loss += loss.item() * inputs.size(0)
        
        if (i + 1) % 20 == 0:
            print(f"  Batch {i + 1}/{len(train_loader)}, Loss: {loss.item():.4f}")
    
    train_loss = running_loss / len(train_loader.dataset)

    # Validation Step
    model.eval()  # Set model to evaluation mode
    val_loss = 0.0
    with torch.no_grad():
        for inputs, labels in val_loader:
            inputs, labels = inputs.to(device), labels.to(device)
            outputs = model(inputs)
            loss = criterion(outputs, labels)
            val_loss += loss.item() * inputs.size(0)
    
    val_loss /= len(val_loader.dataset)

    # Print both training and validation loss
    print(f"Epoch {epoch + 1}/{num_epochs}, Train Loss: {train_loss:.4f}, Val Loss: {val_loss:.4f}")

    scheduler.step()

# Save the trained model
torch.save({
    'model_state_dict': model.state_dict(),
    'class_to_index': train_dataset.class_to_index  # Save label mappings
}, "dfu_backend/models/ulcer_classification_mobilenetv3.pth")
print(" Model saved as ulcer_classification_mobilenetv3.pth")

# Model Evaluation
model.eval()
all_labels = []
all_preds = []
with torch.no_grad():
    for inputs, labels in val_loader:  # Use validation data for final evaluation
        inputs, labels = inputs.to(device), labels.to(device)
        outputs = model(inputs)
        _, preds = torch.max(outputs, 1)
        all_labels.extend(labels.numpy())
        all_preds.extend(preds.numpy())

# Compute Metrics
accuracy = accuracy_score(all_labels, all_preds)
precision = precision_score(all_labels, all_preds, average='weighted', zero_division=1)
recall = recall_score(all_labels, all_preds, average='weighted', zero_division=1)
f1 = f1_score(all_labels, all_preds, average='weighted', zero_division=1)

print("Accuracy:", accuracy)
print("Precision:", precision)
print("Recall:", recall)
print("F1-score:", f1)

# Confusion Matrix
conf_matrix = confusion_matrix(all_labels, all_preds)

plt.figure(figsize=(10, 7))
sns.heatmap(conf_matrix, annot=True, fmt='d', cmap='Blues',
            xticklabels=list(train_dataset.class_to_index.keys()),
            yticklabels=list(train_dataset.class_to_index.keys()))
plt.xlabel('Predicted')
plt.ylabel('True')
plt.title('Confusion Matrix')
plt.show()

# Compute TPR, TNR, FPR, FNR, and Specificity
num_classes = conf_matrix.shape[0]
TPR_per_class = []  # Sensitivity/Recall
FPR_per_class = []
TNR_per_class = []  # Specificity
FNR_per_class = []
specificity_per_class = []

for i in range(num_classes):
    TP = conf_matrix[i, i]  # True Positives
    FN = np.sum(conf_matrix[i, :]) - TP  # False Negatives
    FP = np.sum(conf_matrix[:, i]) - TP  # False Positives
    TN = np.sum(conf_matrix) - (TP + FN + FP)  # True Negatives

    TPR = TP / (TP + FN) if (TP + FN) > 0 else 0  # Sensitivity / Recall
    FPR = FP / (FP + TN) if (FP + TN) > 0 else 0  # False Positive Rate
    TNR = TN / (TN + FP) if (TN + FP) > 0 else 0  # Specificity
    FNR = FN / (TP + FN) if (TP + FN) > 0 else 0  # False Negative Rate
    specificity = TNR  # Specificity is the same as TNR

    TPR_per_class.append(TPR)
    FPR_per_class.append(FPR)
    TNR_per_class.append(TNR)
    FNR_per_class.append(FNR)
    specificity_per_class.append(specificity)

# Compute Weighted Averages
weighted_TPR = np.mean(TPR_per_class)
weighted_FPR = np.mean(FPR_per_class)
weighted_TNR = np.mean(TNR_per_class)
weighted_FNR = np.mean(FNR_per_class)
weighted_specificity = np.mean(specificity_per_class)

# Print Metrics for Each Class
for i, class_name in enumerate(train_dataset.class_to_index.keys()):
    print(f"\nMetrics for {class_name}:")
    print(f"  TPR (Sensitivity/Recall): {TPR_per_class[i]:.4f}")
    print(f"  FPR (False Positive Rate): {FPR_per_class[i]:.4f}")
    print(f"  TNR (Specificity): {TNR_per_class[i]:.4f}")
    print(f"  FNR (False Negative Rate): {FNR_per_class[i]:.4f}")

# Print Overall Metrics
print("\nOverall Metrics (Weighted Averages):")
print(f"Weighted TPR (Sensitivity/Recall): {weighted_TPR:.4f}")
print(f"Weighted FPR (False Positive Rate): {weighted_FPR:.4f}")
print(f"Weighted TNR (Specificity): {weighted_TNR:.4f}")
print(f"Weighted FNR (False Negative Rate): {weighted_FNR:.4f}")
print(f"Weighted Specificity: {weighted_specificity:.4f}")
