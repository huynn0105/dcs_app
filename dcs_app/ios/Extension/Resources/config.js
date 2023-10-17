// Environment: 'local': Local, 'dev': Dev, 'qa': QA, 'demo': Demo, 'production': Production, 'production_ca': Canada Production
export const current_environment = "qa";
export const be_environments = {
  "vagrant": "http://192.168.30.30:3000",
  "local": "http://localhost:3000",
  "dev": "https://dev.directivecommunications.com",
  "qa": "https://qa.directivecommunications.com",
  "demo": "https://demo.directivecommunications.com",
  "production": "https://app.directivecommunications.com",
  "production_ca": "https://app.directivecommunications.ca",
  "qa_ca": "https://qa.directivecommunications.ca",
  "demo_ca": "https://demo.directivecommunications.ca",
  "dev_ca": "https://dev.directivecommunications.ca",
};

export const current_browser = 'CHROME';
export const pp_version = 'DCS Portfolio Plus 1.2.48';
export const full_browser_version = navigator.userAgent;
