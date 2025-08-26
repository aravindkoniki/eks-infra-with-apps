const express = require('express');
const os = require('os');
const app = express();

app.use(express.static('public'));

app.get('/hostname', (req, res) => {
  res.send(os.hostname());
});

// Default to 8080 instead of 80 (non-root safe)
const port = process.env.PORT || 8080;

app.listen(port, () => {
  console.log(`App running on port ${port}`);
});
