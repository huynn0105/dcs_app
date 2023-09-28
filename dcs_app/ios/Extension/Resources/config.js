// Environment: 'local': Local, 'dev': Dev, 'qa': QA, 'demo': Demo, 'production': Production
var current_environment = "qa";
var be_environments = {
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

var current_browser = 'CHROME';
var pp_version = 'DCS Portfolio Plus 1.2.45';
var full_browser_version = navigator.userAgent;
