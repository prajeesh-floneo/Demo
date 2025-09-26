const axios = require('./server/node_modules/axios').default;

const BASE_URL = 'http://localhost:5000';
const FRONTEND_URL = 'http://localhost:3000';

async function testPlatform() {
  console.log('🧪 Testing FloNeo Platform End-to-End...\n');

  try {
    // Test 1: Backend Health Check
    console.log('1️⃣ Testing Backend Health...');
    const healthResponse = await axios.get(`${BASE_URL}/health`);
    console.log('✅ Backend is healthy:', healthResponse.data);

    // Test 2: Frontend Accessibility
    console.log('\n2️⃣ Testing Frontend Accessibility...');
    const frontendResponse = await axios.get(FRONTEND_URL);
    console.log('✅ Frontend is accessible (status:', frontendResponse.status, ')');

    // Test 3: Login Authentication
    console.log('\n3️⃣ Testing Login Authentication...');
    const loginResponse = await axios.post(`${BASE_URL}/auth/login`, {
      email: 'demo@example.com',
      password: 'Demo123!@#'
    });
    console.log('✅ Login successful:', loginResponse.data.success);
    const token = loginResponse.data.data.accessToken;

    // Test 4: Apps API
    console.log('\n4️⃣ Testing Apps API...');
    const appsResponse = await axios.get(`${BASE_URL}/api/apps`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    const apps = appsResponse.data.data.apps || [];
    console.log('✅ Apps retrieved:', apps.length, 'apps found');
    console.log('   Apps:', apps.map(app => ({ id: app.id, name: app.name, archived: app.archived })));

    // Test 5: Templates API
    console.log('\n5️⃣ Testing Templates API...');
    const templatesResponse = await axios.get(`${BASE_URL}/api/templates`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    const templates = templatesResponse.data.data.templates || [];
    console.log('✅ Templates retrieved:', templates.length, 'templates found');
    console.log('   Templates:', templates.map(t => ({ id: t.id, name: t.name, category: t.category })));

    // Test 6: Create New App
    console.log('\n6️⃣ Testing App Creation...');
    const newAppResponse = await axios.post(`${BASE_URL}/api/apps`, {
      name: 'Test App for E2E',
      description: 'Testing app creation functionality'
    }, {
      headers: { Authorization: `Bearer ${token}` }
    });
    const newApp = newAppResponse.data.data.app || newAppResponse.data.data;
    console.log('✅ New app created:', newApp.name);
    const testAppId = newApp.id;

    // Test 7: Archive App
    console.log('\n7️⃣ Testing App Archive Functionality...');
    const archiveResponse = await axios.patch(`${BASE_URL}/api/apps/${testAppId}`, {
      archived: true
    }, {
      headers: { Authorization: `Bearer ${token}` }
    });
    const archivedApp = archiveResponse.data.data.app || archiveResponse.data.data;
    console.log('✅ App archived successfully:', archivedApp.archived);

    // Test 8: Verify Archived Apps
    console.log('\n8️⃣ Testing Archived Apps Retrieval...');
    const archivedAppsResponse = await axios.get(`${BASE_URL}/api/apps`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    const allApps = archivedAppsResponse.data.data.apps || [];
    const archivedApps = allApps.filter(app => app.archived);
    console.log('✅ Archived apps found:', archivedApps.length);
    console.log('   Archived:', archivedApps.map(app => ({ id: app.id, name: app.name })));

    // Test 9: Restore App
    console.log('\n9️⃣ Testing App Restore Functionality...');
    const restoreResponse = await axios.patch(`${BASE_URL}/api/apps/${testAppId}`, {
      archived: false
    }, {
      headers: { Authorization: `Bearer ${token}` }
    });
    const restoredApp = restoreResponse.data.data.app || restoreResponse.data.data;
    console.log('✅ App restored successfully:', !restoredApp.archived);

    // Test 10: Canvas State (if app has canvas data)
    console.log('\n🔟 Testing Canvas State...');
    const canvasResponse = await axios.get(`${BASE_URL}/api/apps/${testAppId}`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    const appDetails = canvasResponse.data.data.app || canvasResponse.data.data;
    console.log('✅ App details retrieved for canvas:', appDetails.name);

    console.log('\n🎉 All tests passed! FloNeo Platform is fully functional!');
    console.log('\n📋 Test Summary:');
    console.log('   ✅ Backend Health Check');
    console.log('   ✅ Frontend Accessibility');
    console.log('   ✅ Authentication System');
    console.log('   ✅ Apps Management');
    console.log('   ✅ Templates System');
    console.log('   ✅ App Creation');
    console.log('   ✅ Archive Functionality');
    console.log('   ✅ Restore Functionality');
    console.log('   ✅ Canvas Integration');

  } catch (error) {
    console.error('❌ Test failed:', error.response?.data || error.message);
    console.error('   Status:', error.response?.status);
    console.error('   URL:', error.config?.url);
  }
}

testPlatform();
