#!/usr/bin/perl
use strict;
use warnings;
use utf8;
binmode STDOUT, ":utf8";
# # https://perlmaven.com/how-to-read-a-csv-file-using-perl

# Object interface
use Text::CSV_XS;
 
my @rows;
# Read/parse CSV
my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";
my $csv = Text::CSV_XS->new ({ binary => 1, allow_loose_quotes => 1, eol => "\n" });
open my $fh, "<:encoding(utf8)", $file or die "Could not open '$file' $!\n";
#while (my $row = $csv->getline ($fh)) {
while (my $line = <$fh>) {
	chomp $line;
	  if ($csv->parse($line)) {
	 
	      my @fields = $csv->fields();
	      # push @rows, [$fields[0],$fields[1],$fields[2],$fields[3],$fields[4],$fields[5],$fields[6],$fields[7],$fields[8],$fields[9],$fields[10],$fields[11],$fields[15],$fields[16],$fields[17],$fields[18],$fields[19],$fields[20],$fields[21],$fields[22],$fields[23],$fields[25],$fields[26],$fields[28],$fields[29],$fields[31],$fields[32],$fields[33],$fields[34],$fields[35],$fields[36],$fields[37],$fields[38],$fields[39],$fields[40],$fields[41],$fields[42],$fields[43],$fields[44],$fields[45],$fields[49],$fields[51],$fields[52],$fields[53],$fields[54],$fields[55]];
	      # ID,crm_id,entityVersion,city,addressCountry,postcode,province,street,countryOfBirth,door,floor,manualAddress,bankAccount,shortBankAccount,bankAccountVerified,contractDeliveryMethod,invoiceDeliveryMethod,marketingPermission,marketingPermissionPaper,marketingPermissionPhone,consentForAgentContact,marketingPermissionEmailOrSms,country,preferredLanguage,email,firstName,identifier,lastName,legacyCustomerNumber,msisdn,password,referenceNumber,updated,authBank,disableLogin,onHold,disableDraw,disableSms,dwh_sync,gender,preDueDateReminderSMS,msisdn2,deviceToken,pin,registered,tempIdentifier,secondFirstName,secondLastName,personalDocumentNumber,dateOfBirth,taxIdentificationNumber,countryStateOfBirth,nationality,facebookToken,onHoldReason,dwh_updated
	      push @rows, [$fields[0],$fields[1],$fields[3],$fields[4],$fields[5],$fields[6],$fields[7],$fields[10],$fields[11],$fields[12],$fields[13],$fields[14],$fields[15],$fields[16],$fields[17],$fields[18],$fields[19],$fields[20],$fields[21],$fields[22],$fields[23],$fields[24],$fields[25]];
	 
	  } else {
	      warn "Line could not be parsed: $line\n";
	  }
    #push @rows, [$row->[55]];
    }
close $fh;


print scalar @rows;
print "\n";
# and write as CSV
open $fh, ">:encoding(utf8)", "borrar.txt" or die "new.csv: $!";
$csv->say ($fh, $_) for @rows;
close $fh or die "new.csv: $!";
