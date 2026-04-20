class ReportingAgent:
    """
    Agent responsible for synthesizing raw AI data into clinical summaries.
    Provides actionable insights based on prediction severity.
    """
    def generate_summary(self, diagnosis: dict):
        stage = diagnosis['stage']
        
        clinical_guidelines = {
            0: "No immediate action required. Maintain standard hygiene.",
            1: "Mild irritation. Apply recommended ointment and monitor for 24 hours.",
            2: "Moderate ulceration detected. Schedule a clinical cleaning and debridement.",
            3: "CRITICAL: Potential neural/vascular damage. Immediate hospitalization recommended."
        }
        
        summary = {
            "title": "Clinical screening Summary",
            "primary_note": clinical_guidelines.get(stage, "Contact your specialist."),
            "urgency": "High" if stage >= 2 else "Routine",
            "follow_up": "Within 48 hours" if stage >= 1 else "Standard bi-weekly"
        }
        
        return summary

# Instance for agent registry
reporting_agent = ReportingAgent()
