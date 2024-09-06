// Global constant for content map


// Salt for hashing
const salt = "IgsTreasureHunt2024";

const video = document.getElementById('video');
const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');
const scanButton = document.getElementById('scanButton');
const videoContainer = document.getElementById('videoContainer');
const startScanButton = document.getElementById('startScan');
const secretCodeInput = document.getElementById('secretCode');
let scanning = false;

async function sha256(message) {
    const msgUint8 = new TextEncoder().encode(message);
    const hashBuffer = await crypto.subtle.digest('SHA-256', msgUint8);
    const hashArray = Array.from(new Uint8Array(hashBuffer));
    return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

async function processCode(code) {
    const hashedCode = await sha256(code + salt);
    console.log("Stuff to hash: " + code + salt)
    console.log("Got hash: " + hashedCode)
    if (contentMap2.hasOwnProperty(hashedCode)) {
        let encrypted = contentMap2[hashedCode]
        console.log("Decrypting: " + encrypted)
        document.getElementById('contentPlaceholder').innerHTML = await decryptContent(code, encrypted);
    } else {
        document.getElementById('contentPlaceholder').innerHTML = "Sorry, that's not the correct code. Try again!";
    }
}

async function decryptContent(password, encryptedContent) {
    const encoder = new TextEncoder();
    const decoder = new TextDecoder();

    // Derive a key from the password
    const keyMaterial = await crypto.subtle.importKey(
        "raw",
        encoder.encode(password),
        {name: "PBKDF2"},
        false,
        ["deriveBits", "deriveKey"]
    );

    const salt = encoder.encode("IgsTreasureHunt2024");
    const key = await crypto.subtle.deriveKey(
        {
            name: "PBKDF2",
            salt: salt,
            iterations: 100000,
            hash: "SHA-256"
        },
        keyMaterial,
        {name: "AES-GCM", length: 256},
        true,
        ["decrypt"]
    );

    // Decode and decrypt the content
    const encryptedData = atob(encryptedContent);
    const iv = new Uint8Array(encryptedData.slice(0, 12).split('').map(char => char.charCodeAt(0)));
    const ciphertext = new Uint8Array(encryptedData.slice(12).split('').map(char => char.charCodeAt(0)));

    try {
        const decrypted = await crypto.subtle.decrypt(
            {name: "AES-GCM", iv: iv},
            key,
            ciphertext
        );
        return decoder.decode(decrypted);
    } catch (e) {
        console.error("Decryption failed", e);
        return null;
    }
}

document.getElementById('submitButton').addEventListener('click', function () {
    processCode(secretCodeInput.value);
});

startScanButton.addEventListener('click', function () {
    scanButton.classList.add('d-none');
    videoContainer.classList.remove('d-none');
    startScanning();
});

function startScanning() {
    navigator.mediaDevices.getUserMedia({
        video: {
            facingMode: "environment",
            aspectRatio: {ideal: 4 / 3},  // A more "square" ratio might correspond to a narrower lens
            zoom: {ideal: 2.0},
        }
    })
        .then(function (stream) {
            let track = stream.getTracks()[0]
            if ('focusMode' in track.getCapabilities()) {
                track.applyConstraints({advanced: [{focusMode: 'continuous'}]})
                    .then(() => console.log('Continuous autofocus enabled'))
                    .catch(error => console.error('Failed to enable continuous autofocus:', error));
            }

            scanning = true;
            video.srcObject = stream;
            video.setAttribute("playsinline", true);
            video.play();
            requestAnimationFrame(tick);
        })
        .catch(function (err) {
            console.error("Error accessing the camera", err);
            alert("Error accessing the camera. Please make sure you've granted camera permissions." + err);
            resetScanButton();
        });
}

function stopScanning() {
    scanning = false;
    if (video.srcObject) {
        video.srcObject.getTracks().forEach(track => track.stop());
    }
    resetScanButton();
}

function resetScanButton() {
    videoContainer.classList.add('d-none');
    scanButton.classList.remove('d-none');
}

function tick() {
    if (video.readyState === video.HAVE_ENOUGH_DATA && scanning) {
        canvas.height = video.videoHeight;
        canvas.width = video.videoWidth;
        ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
        var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
        var code = jsQR(imageData.data, imageData.width, imageData.height, {
            inversionAttempts: "dontInvert",
        });
        if (code) {
            secretCodeInput.value = code.data;
            stopScanning();
        }
    }
    if (scanning) {
        requestAnimationFrame(tick);
    }
}

