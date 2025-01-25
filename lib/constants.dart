// ignore_for_file: non_constant_identifier_names, constant_identifier_names

String BLUETOOTH_PREFIX = 'theq-';

const int BLUETOOTH_SEARCH_TIMEOUT = 45; // in seconds

String LOCAL_ADDRESS = "http://{{LOCAL_IP}}:5002/qsim/ping";
String LOCAL_VARIABLE = "{{LOCAL_IP}}";

String PUBLIC_DOMAIN = "http://theq-{{QUOKKA_ID}}.quokkacomputing.com";
String PUBLIC_ADDRESS = "$PUBLIC_DOMAIN/qsim/ping";
String DOMAIN_VARIABLE = "{{QUOKKA_ID}}";

// Each device entry is a string with fields separated by tabs:
// device_id  device_name  device_ip
// Each entry is separated by a new line character "\n"
String KNOWN_QUOKKAS_KEY = 'KNOWN_QUOKKAS';
