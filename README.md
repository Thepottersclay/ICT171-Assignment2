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

### Route 53
Using Route 53 to attach a domain name to the server is an important step for long term use, using the Elastic IP to ensure that downtime on the server doesn't have any effect on the front-end website.
#### Elastic IP
1. Navigate to the instance.
2. Go to the "Elastic IP Address" field in the "Details" tab.
   - If their is no Elastic IP assigned:
   - Navigate to Elastic IP within the Networking section of the instance details.
   - Allocate an Elastic IP to the instance (E.g. 52.63.227.173)
#### Squarespace for DNS
1. Go to `domains.squarespace.com`
2. Create an account if you don't have one.
3. Enter the domain name of your choosing (E.g. `thepottersclay.com.au`)
4. Select the Top Level Domain (TLD) type to suit you if required.
5. Enter your card details where needed.
6. Go to your dashboard to view the newly created Domain Name.
#### Route 53 Hosted Zone
1. Search for Route 53 on AWS and go to the service.
2. In the hosted zones, create a new hosted zone.
3. Endter the newly created domain name (`thepottersclay.com.au`).
4. Select (Public Hosted Zone).
5. CRUCIAL! Write Down the four name servers for later.
   - ns-1316.awsdns-36.org
   - ns-1688.awsdns-19.co.uk
   - ns-454.awsdns-56.com
   - ns-981.awsdns-58.net
#### Back to Squarespace/NS Update
1. Locate `Domains` in your squarespace account.
2. Go to `Domain Nameservers`.
3. Remove the squarespace defaults.
4. Replace with the 4 that were written down earlier.
5. **Important!** Navigate to DNS settings.
6. Delete any/all Squarespace records.
7. Save all changes.
#### Back to Route 53/Create Records
##### "A" Record (root domain)
1. Create record.
2. Record Name: Not applicable.
3. Record Type: `A`.
4. Value: Elastic IP from your instance (52.63.227.173)
5. Create records.
##### "CNAME" Record ('www' subdomain)
1. Create Record.
2. Record Name: `www`
3. Recird Type: `CNAME`
4. Value: `thepottersclay.com.au`
5. Create records.
#### Verify Propegation
1. Go to `dnschecker.org`
2. Enter `thepottersclay.com.au`
   - Check for `NS` records.
   - Check for `A` records.
3. Enter `www.thepottersclay.com.au`
   - Check `CNAME` records.
4. Flush the DNS cache (`ipconfig /flushdns` for windows)
5. Go to your browser and enter `http://thepottersclay.com.au` & `http://www.thepottersclay.com.au`


 
