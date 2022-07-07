// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'https:\\messagebird?param=1&param=2';
Pattern p = Pattern.compile('([^?]+)\\??(.*)');
Matcher m = p.matcher(url);
m.matches();
System.debug(m.group(1));
System.debug(m.group(2));