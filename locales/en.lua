local Translations = {
    error = {
        file_type = 'Error: Only JSON files are allowed.',
        file_name = 'Error: File name cannot contain a '/' character.',
        other_app = 'Please Use %{appLabel} ',
        file_load = 'File Created: %{file}',
        failed = ' FAILED!',
        breach = 'DATA BREACH DETECTED, DEVICE SHUTTING DOWN',
    },
    info = {
        up = 'Move Up',
        down = 'Move Down',
        left = 'Move Left',
        right = 'Move Right',
        select = 'Select',
        add_pressure = 'Add Pressure',
        reduce_pressure = 'Reduce Pressure',
        add_speed = 'Add Speed/Size',
        reduce_speed = 'Reduce Speed/Size'
    },
    labels = {
        down_n_out = 'Down&Out.exe',
        bruteforce = 'BruteForce.exe',
        hackconnect = 'HackConnect.exe',
        local_drive = 'Local Disk (C:)',
        power = 'Power Off',
        my_computer = 'My Computer',
        usb_device = 'External Device (F:)',
        network = 'Network',
        load_one = 'Writing data to buffer..',
        load_two = 'Executing malicious code..',
    },
    success = {
        success = ' SUCCESSFUL!',
        secured = 'DATA SECURED, DEVICE SHUTTING DOWN',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})