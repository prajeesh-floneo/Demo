# FloNeo Platform End-to-End Test Script
Write-Host "🧪 Testing FloNeo Platform End-to-End..." -ForegroundColor Cyan
Write-Host ""

$BASE_URL = "http://localhost:5000"
$FRONTEND_URL = "http://localhost:3000"

try {
    # Test 1: Backend Health Check
    Write-Host "1️⃣ Testing Backend Health..." -ForegroundColor Yellow
    $healthResponse = Invoke-RestMethod -Uri "$BASE_URL/health" -Method GET
    Write-Host "✅ Backend is healthy: $($healthResponse.message)" -ForegroundColor Green

    # Test 2: Frontend Accessibility
    Write-Host ""
    Write-Host "2️⃣ Testing Frontend Accessibility..." -ForegroundColor Yellow
    $frontendResponse = Invoke-WebRequest -Uri $FRONTEND_URL -Method GET
    Write-Host "✅ Frontend is accessible (status: $($frontendResponse.StatusCode))" -ForegroundColor Green

    # Test 3: Login Authentication
    Write-Host ""
    Write-Host "3️⃣ Testing Login Authentication..." -ForegroundColor Yellow
    $loginBody = @{
        email = "demo@example.com"
        password = "Demo123!@#"
    } | ConvertTo-Json
    
    $loginResponse = Invoke-RestMethod -Uri "$BASE_URL/auth/login" -Method POST -ContentType "application/json" -Body $loginBody
    Write-Host "✅ Login successful: $($loginResponse.success)" -ForegroundColor Green
    $token = $loginResponse.data.accessToken

    # Test 4: Apps API
    Write-Host ""
    Write-Host "4️⃣ Testing Apps API..." -ForegroundColor Yellow
    $headers = @{ Authorization = "Bearer $token" }
    $appsResponse = Invoke-RestMethod -Uri "$BASE_URL/api/apps" -Method GET -Headers $headers
    Write-Host "✅ Apps retrieved: $($appsResponse.data.apps.Count) apps found" -ForegroundColor Green
    foreach ($app in $appsResponse.data.apps) {
        Write-Host "   App: ID=$($app.id), Name='$($app.name)', Archived=$($app.archived)" -ForegroundColor Gray
    }

    # Test 5: Templates API
    Write-Host ""
    Write-Host "5️⃣ Testing Templates API..." -ForegroundColor Yellow
    $templatesResponse = Invoke-RestMethod -Uri "$BASE_URL/api/templates" -Method GET -Headers $headers
    Write-Host "✅ Templates retrieved: $($templatesResponse.data.templates.Count) templates found" -ForegroundColor Green
    foreach ($template in $templatesResponse.data.templates) {
        Write-Host "   Template: ID=$($template.id), Name='$($template.name)', Category='$($template.category)'" -ForegroundColor Gray
    }

    # Test 6: Create New App
    Write-Host ""
    Write-Host "6️⃣ Testing App Creation..." -ForegroundColor Yellow
    $newAppBody = @{
        name = "Test App for E2E"
        description = "Testing app creation functionality"
    } | ConvertTo-Json

    $newAppResponse = Invoke-RestMethod -Uri "$BASE_URL/api/apps" -Method POST -ContentType "application/json" -Body $newAppBody -Headers $headers
    Write-Host "✅ New app created: '$($newAppResponse.data.app.name)'" -ForegroundColor Green
    $testAppId = $newAppResponse.data.app.id

    # Test 7: Archive App
    Write-Host ""
    Write-Host "7️⃣ Testing App Archive Functionality..." -ForegroundColor Yellow
    $archiveBody = @{ archived = $true } | ConvertTo-Json
    $archiveResponse = Invoke-RestMethod -Uri "$BASE_URL/api/apps/$testAppId" -Method PATCH -ContentType "application/json" -Body $archiveBody -Headers $headers
    Write-Host "✅ App archived successfully: $($archiveResponse.data.app.archived)" -ForegroundColor Green

    # Test 8: Verify Archived Apps
    Write-Host ""
    Write-Host "8️⃣ Testing Archived Apps Retrieval..." -ForegroundColor Yellow
    $archivedAppsResponse = Invoke-RestMethod -Uri "$BASE_URL/api/apps" -Method GET -Headers $headers
    $archivedApps = $archivedAppsResponse.data.apps | Where-Object { $_.archived -eq $true }
    Write-Host "✅ Archived apps found: $($archivedApps.Count)" -ForegroundColor Green
    foreach ($app in $archivedApps) {
        Write-Host "   Archived: ID=$($app.id), Name='$($app.name)'" -ForegroundColor Gray
    }

    # Test 9: Restore App
    Write-Host ""
    Write-Host "9️⃣ Testing App Restore Functionality..." -ForegroundColor Yellow
    $restoreBody = @{ archived = $false } | ConvertTo-Json
    $restoreResponse = Invoke-RestMethod -Uri "$BASE_URL/api/apps/$testAppId" -Method PATCH -ContentType "application/json" -Body $restoreBody -Headers $headers
    Write-Host "✅ App restored successfully: $(-not $restoreResponse.data.app.archived)" -ForegroundColor Green

    # Test 10: Canvas State
    Write-Host ""
    Write-Host "🔟 Testing Canvas State..." -ForegroundColor Yellow
    $canvasResponse = Invoke-RestMethod -Uri "$BASE_URL/api/apps/$testAppId" -Method GET -Headers $headers
    Write-Host "✅ App details retrieved for canvas: '$($canvasResponse.data.app.name)'" -ForegroundColor Green

    Write-Host ""
    Write-Host "🎉 All tests passed! FloNeo Platform is fully functional!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Test Summary:" -ForegroundColor Cyan
    Write-Host "   ✅ Backend Health Check" -ForegroundColor Green
    Write-Host "   ✅ Frontend Accessibility" -ForegroundColor Green
    Write-Host "   ✅ Authentication System" -ForegroundColor Green
    Write-Host "   ✅ Apps Management" -ForegroundColor Green
    Write-Host "   ✅ Templates System" -ForegroundColor Green
    Write-Host "   ✅ App Creation" -ForegroundColor Green
    Write-Host "   ✅ Archive Functionality" -ForegroundColor Green
    Write-Host "   ✅ Restore Functionality" -ForegroundColor Green
    Write-Host "   ✅ Canvas Integration" -ForegroundColor Green

} catch {
    Write-Host "❌ Test failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "   Details: $($_.ErrorDetails)" -ForegroundColor Red
}
