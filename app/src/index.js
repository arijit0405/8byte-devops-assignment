const express = require("express");

const app = express();
const PORT = process.env.PORT || 3000;

app.get("/", (req, res) => {
  res.json({
    status: "ok",
    message: "8byte DevOps assignment app is running ,  CI/CD version 2"
  });
});

app.get("/health", (req, res) => {
  res.send("OK");
});

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Server started on port ${PORT}`);
  });
}

module.exports = app;
