import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';
import { spawn, exec } from 'child_process';
import path from 'path';
import process from 'process';
import { fileURLToPath } from 'url';
import chokidar from 'chokidar';
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

const projectRoot = findProjectRoot(__dirname, 'BlazorApp2');
const blazorProjectPath = path.join(projectRoot, 'BlazorApp2');
const blazorExecutablePath = path.join(blazorProjectPath, 'bin', 'Debug', 'net8.0');
console.log(`Building Blazor project at path: ${blazorProjectPath}`);

let blazorProcess;

const runBlazorApp = () => {
    const blazorExecutable = path.join(blazorExecutablePath, 'BlazorApp2.exe');
    blazorProcess = spawn(blazorExecutable, { stdio: 'inherit' });
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

// Watch the Blazor project directory for changes
//const watcher = chokidar.watch(blazorProjectPath, { ignored: /node_modules|\.git|\.vs|bin|obj/, ignoreInitial: true });
//watcher.on('all', (event, path) => {
//    console.log(`Detected ${event} in ${path}, rebuilding application...`);
//    buildAndStartBlazor();
//});

// Middleware to log all requests
app.use((req, res, next) => {
    console.log(`Request received: ${req.method} ${req.url}`);
    next();
});

// Proxy configuration to handle API and other requests
app.use('/api/', createProxyMiddleware({
    target: 'http://localhost:5000/', // Correct port
    changeOrigin: true,
    ws: true
}));

// Proxy configuration to handle API and other requests
app.use('/favicon.png', createProxyMiddleware({
    target: 'http://localhost:5000/', // Correct port
    changeOrigin: true,
    pathRewrite: {'^/': '/favicon.png'}
}));


app.use('/app.css', createProxyMiddleware({
    target: 'http://localhost:5000', // Correct port
    changeOrigin: true,
    pathRewrite: {'^/': '/app.css'}
}));

app.use('/bootstrap/', createProxyMiddleware({
    target: 'http://localhost:5000/bootstrap/', // Correct port
    changeOrigin: true
}));

app.use('/_blazor/', createProxyMiddleware({
    target: 'http://localhost:5000/_blazor/', // Correct port
    changeOrigin: true
}));

app.use('/_framework', createProxyMiddleware({
   target:"http://localhost:5000/_framework/",
   changeOrigin: true 
}));

app.use('/BlazorApp2.styles.css', createProxyMiddleware({
    target:"http://localhost:5000",
    changeOrigin: true,
    pathRewrite: {'^/': '/BlazorApp2.styles.css'}
}));

app.use('/', createProxyMiddleware({
    target: 'http://localhost:5173', // Assuming React runs on port 3000
    changeOrigin: true,
    ws: true // Enable websocket proxy for hot module replacement
}));

const PORT = 8888;
app.listen(PORT, () => {
    console.log(`Proxy server running on http://localhost:${PORT}`);
});

process.on('exit', () => {
    if (blazorProcess) blazorProcess.kill();
});

