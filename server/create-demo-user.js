const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');

const prisma = new PrismaClient();

async function createDemoUser() {
  try {
    console.log('🔍 Checking if demo user exists...');
    
    const existingUser = await prisma.user.findUnique({
      where: { email: 'demo@example.com' }
    });

    if (existingUser) {
      console.log('✅ Demo user already exists!');
      console.log(`User ID: ${existingUser.id}`);
      console.log(`Email: ${existingUser.email}`);
      console.log(`Role: ${existingUser.role}`);
      return;
    }

    console.log('👤 Creating demo user...');
    
    const hashedPassword = await bcrypt.hash('Demo123!@#', 12);
    
    const demoUser = await prisma.user.create({
      data: {
        email: 'demo@example.com',
        password: hashedPassword,
        role: 'developer',
        verified: true
      }
    });

    console.log('✅ Demo user created successfully!');
    console.log(`User ID: ${demoUser.id}`);
    console.log(`Email: ${demoUser.email}`);
    console.log(`Role: ${demoUser.role}`);
    
  } catch (error) {
    console.error('❌ Error creating demo user:', error);
  } finally {
    await prisma.$disconnect();
  }
}

createDemoUser();
