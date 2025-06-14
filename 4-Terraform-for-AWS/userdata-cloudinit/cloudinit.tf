# ============================================================================================
# Purpose:
# This configuration prepares a cloud-init script that will be used to configure an EC2 
# instance at launch. It loads a user-defined configuration file and packages it into a 
# format usable by EC2 cloud-init.

# Key Concepts:
# - template_file: Reads and optionally interpolates a configuration file
# - template_cloudinit_config: Combines multiple cloud-init parts into a single MIME message
#   suitable for use with EC2 user_data

# ============================================================================================

# Load the configuration file content from init.cfg
data "template_file" "install-apache" {
    template = file("init.cfg")                # Reads the local init.cfg file
}

# Convert the loaded template into a cloud-init compatible format
data "template_cloudinit_config" "install-apache-config" {
    gzip          = false                      # Do not compress the content
    base64_encode = false                      # Do not encode the content in base64

    part {
        filename     = "init.cfg"              # Set the name of the part for identification
        content_type = "text/cloud-config"     # Specify that the file is a cloud-config file
        content      = data.template_file.install-apache.rendered  # Use the rendered config
    }
}

