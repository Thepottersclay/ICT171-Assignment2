# ICT171-Assignment2
This document is in place so that in the event of a full server criticality, one can rely soley on the instructions below, to get a server replicate up and running in a matter of hours. Each step of the server development process will be made up of written instructions, command line code segments,  accompanied by detailed images for crucial steps, and all command line code segments which can be copy/pasted for convenience, especially in file changing, and screenshots of important outputs.


## AWS Setup Instructions
### EC2
Assuming that one already has access to Amazon EC2, this set of instructions has all of the necessary steps for creating the EC2 instance.
1. From the EC2 dashboard, launch a new instance.
2. Name the server, in this case (steele_35500984_ICT171_Assign2_Sem1_2025).
3. Choose the OS: Ubuntu
4. Instance Type: t2.micro
5. Keypair (for SSH login): KEEP SAFE and DON'T LOSE
   - Create New Keypair.
   - Name: (ICT171)
   - Keypair Type: RSA
   - Format: `.pem`
6. Network Settings:
   - Security Groups:
   - Allow SSH (22), HTTPS (443), HTTP (80)
7. Configure Storage:
   - Change from  `1x 8GiB` to `1x 30GiB`
8. Launch Instance



 
