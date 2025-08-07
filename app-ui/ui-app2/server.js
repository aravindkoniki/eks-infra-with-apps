const express = require('express');
const os = require('os');
const app = express();

app.use(express.static('public'));

app.get('/hostname', (req, res) => {
  res.send(os.hostname());
});

const port = process.env.PORT || 80;
app.listen(port, () => {
  console.log(`App running on port ${port}`);
});