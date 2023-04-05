const express = require('express');
// const Razorpay = require('razorpay');

// const keyFiles = require('./keyFiles');

// const razorpayInstance = new Razorpay({
//     key_id: razorPayKeyId,
//     key_secret: razorPaySecretKey
// });

const app = express();

app.post('/verifyOrder', (req, res, next) => {
    // STEP 1: Receive Payment Data
    // const formData = JSON.parse(req.body);

    console.log(req.body);

    return;

    const razorpay_signature = formData['razorpay_signature'];
    const razorpay_order_id = formData['razorpay_order_id'];
    const razorpay_payment_id = formData['razorpay_payment_id'];
    // const razorpay_signature = req.headers['x-razorpay-signature'];

    // Pass yours key_secret here
    const key_secret = razorPaySecretKey;

    // STEP 2: Verification & Send Response to User

    // Creating hmac object
    let hmac = crypto.createHmac('sha256', key_secret);

    // Passing the data to be hashed
    hmac.update(razorpay_order_id + "|" + razorpay_payment_id);

    // Creating the hmac in the required format
    const generated_signature = hmac.digest('hex');


    if (razorpay_signature === generated_signature) {
        res.json({ success: true, message: "Payment has been verified" })
    }
    else
        res.json({ success: false, message: "Payment verification failed" })
});


app.listen(3000, '192.168.81.153');