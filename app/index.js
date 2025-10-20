const express = require('express');
const AWS = require('aws-sdk');
const app = express();
app.use(express.json());

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

app.post('/api/patient', async (req, res) => {
  const data = req.body;
  // Example: Store data in S3 (stub)
  // const s3 = new AWS.S3();
  // await s3.putObject({ Bucket: process.env.S3_BUCKET, Key: `patient-${Date.now()}.json`, Body: JSON.stringify(data) }).promise();
  res.status(201).json({ message: 'Patient data processed', data });
});

const PORT = process.env.PORT || 80;
app.listen(PORT, () => {
  console.log(`Health dashboard API running on port ${PORT}`);
});
