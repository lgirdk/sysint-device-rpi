<?php
/*
 If not stated otherwise in this file or this component's Licenses.txt file the
 following copyright and licenses apply:
 Copyright 2016 RDK Management
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/
?>
<?php include('../includes/actionHandlerUtility.php') ?>
<?php

if (!isset($_SESSION["loginuser"])) {
        echo '<script type="text/javascript">alert("'._("Please Login First!").'"); location.href="../index.php";</script>';
        exit(0);
}

$jsConfig = $_POST['configInfo'];
$arConfig = json_decode($jsConfig, true);
$key_enc_dec = $arConfig['key'];

exec('openssl enc -e -aes-256-cbc -in /nvram/syscfg.db -out /nvram/syscfg.enc -k '.$key_enc_dec);
exec('openssl enc -e -aes-256-cbc -in /nvram/bbhm_bak_cfg.xml -out /nvram/bbhm_bak_cfg.enc -k '.$key_enc_dec);
exec('openssl enc -e -aes-256-cbc -in /nvram/bbhm_cur_cfg.xml -out /nvram/bbhm_cur_cfg.enc -k '.$key_enc_dec);
exec('openssl enc -e -aes-256-cbc -in /nvram/hostapd0.conf -out /nvram/hostapd0.enc -k '.$key_enc_dec);
exec('openssl enc -e -aes-256-cbc -in /nvram/hostapd1.conf -out /nvram/hostapd1.enc -k '.$key_enc_dec);
$response_message = _("Success!");

$response->error_message = $response_message;
echo htmlspecialchars(json_encode($response), ENT_NOQUOTES, 'UTF-8');
?>
