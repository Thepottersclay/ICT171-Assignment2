# ICT171-Assignment2
This file is created in such a way that in the event of a full server criticality, one can follow the instructions below and have 


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



 
