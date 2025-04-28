# Automated Backup Script

I made this script to backup my minecraft server from my debian server

The script utilizes `curl` for making HTTP requests and `jq` for parsing JSON responses from the API. It is intended to be run on a Linux server.

---

## Usage Guide

### Requirements

- **curl**: A command-line tool for transferring data with URLs.
- **jq**: A lightweight and flexible command-line JSON processor.
- **GoFile API Token**: You’ll need an API token from GoFile to interact with their API.
- **GoFile Parent Folder ID**: The ID of the parent folder where the backup will be uploaded.

### Steps to Use

1. **Clone the Repository**

   ```bash
   git clone https://github.com/LukysGaming/auto-gofile-backup.git
   cd auto-gofile-backup
   ```

2. **Install Dependencies**
   Ensure that `curl` and `jq` are installed on your system. On most Linux distributions, you can install them with:

   ```bash
   sudo apt-get install curl jq
   ```

3. **Configure the Script**
   Open the script (`backup.sh`) and replace the following placeholders:

   - `YOUR_API_TOKEN`: Replace this with your actual GoFile API token.
   - `PARENT_FOLDER_ID`: Replace this with the ID of your "root" folder.

4. **Set the Backup Directory**
   Edit the `BACKUP_DIR` variable in the script to specify the directory that contains the files you want to back up.

5. **Run the Script**
   After making the necessary changes, run the script by executing:

   ```bash
   bash backup.sh
   ```

   The script will create a zip of the specified directory, upload it to GoFile, and clean up the temporary file after the upload is complete.

6. **Monitor the Output**
   After the script finishes, it will provide you with a download link to access your backup from GoFile.

---

## Running the Script Every Day

To automate the backup process and run the script every day, you can set up a cron job.

### Steps to Set Up a Cron Job

1. **Open the Crontab Configuration File**

   Use the `crontab` command to open your cron configuration:

   ```bash
   crontab -e
   ```

2. **Add a New Cron Job**

   To run the script every day at a specific time, add the following line to the crontab file. For example, to run the script at 2:00 AM every day, add this line:

   ```bash
   0 2 * * * /bin/bash /path/to/your/backup-script/backup.sh
   ```

   Make sure to replace `/path/to/your/backup-script/` with the full path to the directory where the script is located.
