<?php 

/**
 * Fabrice Simonet - Emulsion.io
 * 
 * Infimaniak API pour modifier l'IP d'une entrée DNS.
 * DynDns API
 * https://www.infomaniak.com/en/support/faq/2376/dyndns-via-infomaniak-api
 * 
 * Renommer le fichier config.ini.dev en config.ini et modifier les valeurs.
 * 
 */

$config = parse_ini_file("config.ini", true);

// ping un service pour récupérer l'IP publique du serveur local
$ip = file_get_contents("http://ipecho.net/plain");

$domaines = array_map(function($ndd, $name) {
   return ['ndd' => $ndd, 'name' => $name];
}, $config['domaine']['ndd'], $config['domaine']['name']);

foreach ($domaines as $key => $domaine) {

   $response = file_get_contents("https://infomaniak.com/nic/update?hostname={$domaine['name']}.{$domaine['ndd']}&myip={$ip}&username={$config['api']['user']}&password={$config['api']['pass']}");

   if($config['app']['debug']) {
      var_dump($config);
      if ($response === FALSE) {
         echo "file_get_contents Error : FALSE";
      } else {
         echo $response;
      }
   }

}

?>