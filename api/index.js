const express = require("express");
const cors = require("cors");
const fs = require("fs");
const crypto = require("crypto");
const { exec } = require("child_process");
const app = express();
const port = 2900;

app.use(cors());
app.use(express.json({ limit: "50mb" }));

app.post("/compress_image/", async (req, res) => {
  let fileName =
    crypto.randomBytes(20).toString("hex") + "." + req.body?.extension;
  const image = Buffer.from(req.body.image, "base64");
  fs.writeFileSync(fileName, image);
  await exec(
    `mv ${fileName} ../tests; cd ../tests ; node Testeur.js ${req.body.nbCluster} ${req.body.convergence} ${fileName}`
  );
  const compressed = fs.readFileSync("../tests/newGenerated_Img.png", "base64");
  res.send(compressed);
});

app.listen(port, () => {
  console.log("Ready compress Image on port: " + port);
});
