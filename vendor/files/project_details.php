<?php

$fixed = preg_replace_callback ( '!s:(\d+):"(.*?)";!', function($match) {      
    return ($match[1] == strlen($match[2])) ? $match[0] : 's:' . strlen($match[2]) . ':"' . $match[2] . '";';
},$argv[1] );
echo json_encode(unserialize($fixed));