#!/bin/bash

# Update and install Apache
sudo yum update -y
sudo yum install -y httpd

# Start the Apache service and enable it to start on boot
sudo systemctl enable httpd
sudo systemctl start httpd

# Create the index.html file with your content
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to My Terraform Web Server</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f8ff;
            margin: 0;
            padding: 0;
            text-align: center;
        }

        header {
            background-color: #4CAF50;
            color: white;
            padding: 20px;
            font-size: 2em;
        }

        section {
            background-color: #ffffff;
            margin: 20px;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h2 {
            color: #333;
            font-size: 1.5em;
        }

        p {
            color: #555;
            font-size: 1.2em;
            line-height: 1.6;
            margin: 10px 0;
        }

        .highlight {
            color: #1e90ff;
            font-weight: bold;
        }

        footer {
            background-color: #333;
            color: white;
            padding: 10px;
            position: fixed;
            bottom: 0;
            width: 100%;
            text-align: center;
        }
    </style>
</head>
<body>
    <header>
        This website has been created using Terraform by Mr. Ben Ahoure
    </header>

    <section>
        <h2>My Learning Journey</h2>
        <p>
            Becoming one of the best DevOps engineers has been my passion and mission. The road hasn't been easy, but my dedication and willingness to learn have been unwavering. From mastering cloud technologies like AWS to understanding the complexities of automation, monitoring, and infrastructure-as-code, I have invested countless hours in building and honing my skills.
        </p>
        <p>
            My journey started with a desire to solve problems and create scalable, reliable systems. Through various bootcamps and personal projects, I've tackled complex challenges and learned from every failure. The learning process has been demanding but incredibly rewarding, as I've developed both technical expertise and the resilience needed to thrive in fast-paced environments.
        </p>
        <p>
            I am committed to continuous learning, always striving to improve and stay ahead of the curve in an ever-evolving field. With each new skill I acquire, I feel more empowered to contribute to the DevOps community and bring innovation to the teams I work with. I am confident that my drive and work ethic will make me one of the best in this field, and I’m excited for the future.
        </p>
    </section>

    <footer>
        © 2024 Ben Ahoure. All rights reserved.
    </footer>
</body>
</html>
EOF

# Restart Apache to make sure it serves the new index.html file
sudo systemctl restart httpd
