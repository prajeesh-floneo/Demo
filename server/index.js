const express = require('express');
const cors = require('cors');
const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const app = express();
const PORT = 5000;

app.use(cors());
app.use(express.json());

const prisma = new PrismaClient();
const JWT_SECRET = 'your-secret-key'; // Replace with a strong, secure key in production

// Seed initial user with hashed password (run once, then comment out)
async function seedUser() {
  const existingUser = await prisma.user.findUnique({
    where: { email: 'user@example.com' },
  });
  if (!existingUser) {
    const hashedPassword = await bcrypt.hash('password123', 10);
    await prisma.user.create({
      data: { email: 'user@example.com', password: hashedPassword },
    });
    console.log('Seeded user with hashed password');
  }
}
seedUser().then(() => prisma.$disconnect());

// Login endpoint with Prisma and bcrypt
app.post('/api/login', async (req, res) => {
  const { email, password } = req.body;
  const user = await prisma.user.findUnique({
    where: { email },
  });
  if (user && await bcrypt.compare(password, user.password)) {
    const token = jwt.sign({ email: user.email }, JWT_SECRET, { expiresIn: '1h' });
    return res.json({ success: true, token });
  }
  return res.status(401).json({ success: false, message: 'Invalid credentials' });
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});