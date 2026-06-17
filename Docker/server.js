const express = require('express');
const fs = require('fs');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
    res.json({ status: "running", message: "Hello Secure World!" });
});

// A route that simulates a hacker trying to write a malicious script to disk
app.get('/exploit', (req, res) => {
    const maliciousPath = path.join(__dirname, 'malicious_script.sh');
    try {
        fs.writeFileSync(maliciousPath, 'echo "System Compromised!"');
        res.status(200).send("Malicious script written to disk successfully!");
    } catch (err) {
        res.status(500).send(`Exploit Failed: ${err.message}`);
    }
});

app.listen(PORT, () => {
    console.log(`Server executing on port ${PORT}`);
});