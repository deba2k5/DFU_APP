class ReportingAgent:
    """
    Agent responsible for synthesizing raw AI data into clinical summaries.
    Provides actionable insights based on prediction severity.
    """
    def generate_summary(self, diagnosis: dict):
        stage = diagnosis['stage']
        
        clinical_guidelines = {
            0: "No immediate action required. Maintain standard hygiene.",
            1: "Surface ulcer detected. Apply recommended ointment and monitor.",
            2: "Deep ulceration detected. Schedule a clinical cleaning and debridement.",
            3: "Deep ulcer with infection (Osteomyelitis). Immediate antibiotic therapy and clinical care required.",
            4: "Localized Gangrene. Immediate surgical consultation and possible minor amputation required.",
            5: "Extensive Gangrene. Emergency hospitalization and major surgical intervention required."
        }
        
        summary = {
            "title": "Clinical screening Summary",
            "primary_note": clinical_guidelines.get(stage, "Contact your specialist."),
            "urgency": "Emergency" if stage >= 4 else "High" if stage >= 2 else "Routine",
            "follow_up": "Immediate" if stage >= 4 else "Within 24 hours" if stage >= 3 else "Within 48 hours" if stage >= 1 else "Standard bi-weekly"
        }
        
        return summary

# Instance for agent registry
reporting_agent = ReportingAgent()
