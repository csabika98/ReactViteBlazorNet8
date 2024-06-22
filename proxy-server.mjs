import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';
import { spawn, exec } from 'child_process';
import path from 'path';
import process from 'process';
import { fileURLToPath } from 'url';
import fs from 'fs';

const app = express();

// Convert the URL path to a directory path for __dirname
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Function to dynamically find the project root based on directory name
function findProjectRoot(currentDir, targetFolderName) {
    const root = path.parse(currentDir).root;

    while (currentDir !== root) {
        let possiblePath = path.join(currentDir, targetFolderName);
        if (fs.existsSync(possiblePath)) {
            return currentDir; // Return the directory that contains the target folder
        }
        currentDir = path.dirname(currentDir);
    }

    return null; // or handle this case as appropriate (e.g., throw an error or use a default path)
}

const projectRoot = findProjectRoot(__dirname, 'ReactViteBlazorNet8');
const blazorProjectPath = path.join(projectRoot, 'ReactViteBlazorNet8');
console.log(`Building Blazor project at path: ${blazorProjectPath}`);

let blazorProcess;

const runBlazorApp = () => {
    blazorProcess = spawn('dotnet', ['run', '--project', blazorProjectPath], { stdio: 'inherit' });
    blazorProcess.on('close', (code) => {
        console.log(`Blazor process exited with code ${code}`);
    });
};

const buildAndStartBlazor = () => {
    exec(`dotnet build "${blazorProjectPath}"`, (error, stdout, stderr) => {
        if (error) {
            console.error(`Error building the Blazor project: ${error.message}`);
            return;
        }
        if (stderr) {
            console.error(`Build stderr: ${stderr}`);
            return;
        }
        console.log(`Build stdout: ${stdout}`);
        if (blazorProcess) {
            console.log('Restarting Blazor application...');
            blazorProcess.kill(); // Stop the previous instance
        }
        runBlazorApp(); // Start a new instance
    });
};

// Initial build and start
buildAndStartBlazor();

// Middleware to log all requests
app.use((req, res, next) => {
    console.log(`Request received: ${req.method} ${req.url}`);
    next();
});

// Proxy configuration to handle API and other requests
app.use('/api/', createProxyMiddleware({
    target: 'http://localhost:5019/', // Correct port
    changeOrigin: true,
    ws: true
}));

app.use('/favicon.png', createProxyMiddleware({
    target: 'http://localhost:5019/', // Correct port
    changeOrigin: true,
    pathRewrite: {'^/': '/favicon.png'}
}));

app.use('/app.css', createProxyMiddleware({
    target: 'http://localhost:5019', // Correct port
    changeOrigin: true,
    pathRewrite: {'^/': '/app.css'}
}));

app.use('/bootstrap/', createProxyMiddleware({
    target: 'http://localhost:5019/bootstrap/', // Correct port
    changeOrigin: true
}));

app.use('/_blazor/', createProxyMiddleware({
    target: 'http://localhost:5019/_blazor/', // Correct port
    changeOrigin: true
}));

app.use('/_framework', createProxyMiddleware({
    target:"http://localhost:5019/_framework/",
    changeOrigin: true 
}));

app.use('/BlazorApp2.styles.css', createProxyMiddleware({
    target:"http://localhost:5019",
    changeOrigin: true,
    pathRewrite: {'^/': '/BlazorApp2.styles.css'}
}));

app.use('/', createProxyMiddleware({
    target: 'http://localhost:5173', // Assuming React runs on port 3000
    changeOrigin: true,
    ws: false // Enable websocket proxy for hot module replacement
}));

const PORT = 8888;
app.listen(PORT, () => {
    console.log(`Proxy server running on http://localhost:${PORT}`);
});

process.on('exit', () => {
    if (blazorProcess) blazorProcess.kill();
});

