const express = require('express');
const path = require('path');

const app = express();
const PORT = 8080;

// Serve static files from the src and resources directories
app.use(express.static(path.join(__dirname, 'src')));
app.use('/resources', express.static(path.join(__dirname, 'resources')));

// Serve the index.html file directly when accessing the root
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'src', 'index.html'));
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
