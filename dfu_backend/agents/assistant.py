import os
from groq import Groq
from dotenv import load_dotenv

# Load the API key from .env
load_dotenv()

class AIAssistantAgent:
    """
    Agent responsible for providing an interactive medical AI assistant interface.
    Powered by Meta's Llama-4-scout model via Groq.
    """
    def __init__(self):
        self.client = Groq(api_key=os.environ.get("GROQ_API_KEY"))

    def chat_stream(self, user_message: str):
        """
        Streams a response from the Llama-4 model using the Groq API.
        """
        completion = self.client.chat.completions.create(
            model="meta-llama/llama-4-scout-17b-16e-instruct",
            messages=[
                {
                    "role": "system",
                    "content": "You are a specialized medical assistant integrated into a Diabetic Foot Ulcer (DFU) screening platform. Provide concise, clinical, and helpful answers."
                },
                {
                    "role": "user",
                    "content": user_message
                }
            ],
            temperature=1,
            max_completion_tokens=1024,
            top_p=1,
            stream=True,
            stop=None
        )

        for chunk in completion:
            if chunk.choices[0].delta.content:
                yield chunk.choices[0].delta.content

    def get_summary(self, diagnosis_data: str):
        """
        Retrieves a complete summary instead of a stream, useful for generating reports.
        """
        completion = self.client.chat.completions.create(
            model="meta-llama/llama-4-scout-17b-16e-instruct",
            messages=[
                {
                    "role": "system",
                    "content": "You are a specialized medical assistant. Given raw diagnostic data, provide a professional 3-sentence clinical summary and recommendation."
                },
                {
                    "role": "user",
                    "content": f"Please summarize this diagnosis: {diagnosis_data}"
                }
            ],
            temperature=0.7,
            max_completion_tokens=500,
            stream=False
        )
        return completion.choices[0].message.content

# Instance for agent registry
assistant_agent = AIAssistantAgent()
