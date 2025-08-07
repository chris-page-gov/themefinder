# IT Department Email Template - API Key Request

**Subject:** Request for Azure OpenAI API Access for ThemeFinder Project

---

**To:** IT Support / Cloud Services Team  
**From:** [Your Name]  
**Date:** [Today's Date]  
**Subject:** Request for Azure OpenAI API Access for ThemeFinder Project

Dear IT Team,

I am working on implementing **ThemeFinder**, an AI-powered topic modeling tool for analyzing survey responses and public consultation feedback. This tool will help our department process citizen feedback more efficiently and identify key themes in public responses.

**Project Overview:**
- **Tool:** ThemeFinder (Python package for topic modeling)
- **Purpose:** Automated analysis of survey responses and consultation data
- **Use Case:** Processing public feedback to identify themes and sentiment for policy makers
- **Repository:** https://github.com/i-dot-ai/themefinder/

**Required API Access:**
I need access to Azure OpenAI services with the following configuration:

**Option 1: Azure OpenAI (Preferred)**
- `AZURE_OPENAI_API_KEY` - API key for our Azure OpenAI resource
- `AZURE_OPENAI_ENDPOINT` - Endpoint URL (format: https://your-resource-name.openai.azure.com/)
- `OPENAI_API_VERSION` - API version (recommend: 2024-02-15-preview)
- `DEPLOYMENT_NAME` - Name of GPT-4o deployment
- `AZURE_OPENAI_BASE_URL` - Base URL (same as endpoint)

**Option 2: OpenAI Direct (Alternative)**
- `OPENAI_API_KEY` - Direct OpenAI API key

**Technical Requirements:**
- Model access to GPT-4o or GPT-4 for optimal performance
- The tool supports structured outputs and works with various LLM providers
- Estimated usage: [specify your expected volume, e.g., "processing 200-500 responses per analysis"]
- Environment: Development container setup with secure credential management

**Security Considerations:**
- All API keys will be stored in `.env` files (not committed to version control)
- Development environment uses secure container isolation
- Tool is designed for government/public sector use with appropriate data handling

**Business Justification:**
This tool will significantly improve our ability to:
- Process large volumes of public consultation responses efficiently
- Identify key themes and sentiment in citizen feedback automatically
- Provide structured insights for policy decision-making
- Reduce manual analysis time from days/weeks to hours

**Next Steps:**
Could you please advise on:
1. The process for requesting Azure OpenAI access for our department
2. Any security approvals or data governance requirements
3. Whether we have existing Azure OpenAI resources I can use
4. Timeline for provisioning access

I'm happy to provide additional technical details or meet to discuss this request further.

Thank you for your assistance.

Best regards,  
[Your Name]  
[Your Department]  
[Contact Information]

---

**Attachments to consider including:**
- Link to ThemeFinder documentation: https://i-dot-ai.github.io/themefinder/
- This notebook demonstrating the tool's capabilities

---

## Instructions for Use

1. **Customize the placeholders:**
   - Replace `[Your Name]` with your actual name
   - Replace `[Today's Date]` with the current date
   - Replace `[Your Department]` with your department name
   - Replace `[Contact Information]` with your email and phone

2. **Adjust the usage estimate:**
   - Update the "Estimated usage" section with your expected volume
   - Be specific about how many responses you plan to process

3. **Review organizational requirements:**
   - Check if your organization has specific procedures for API requests
   - Consider if you need manager approval before sending
   - Verify if there are existing Azure OpenAI resources you can use

4. **Send to the appropriate team:**
   - IT Support / Cloud Services Team
   - Security team (if required by your organization)
   - Procurement team (if budget approval is needed)
