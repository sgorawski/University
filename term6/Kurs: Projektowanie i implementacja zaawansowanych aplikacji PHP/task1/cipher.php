<?php
if ($argc !== 4) {
    echo "Script needs 3 arguments.\n";
    exit(1);
}

$key = buildKey($argv[1], $argv[2]);
echo encrypt($key, $argv[3]);

function buildKey(string $toSubstitute, string $substitutions): array
{
    return array_combine(str_split($toSubstitute), str_split($substitutions));
}

function encrypt(array $key, string $text): string
{
    return implode(array_map(
        function ($char) use ($key) { return $key[$char] ?? $char; },
        str_split($text)
    ));
}
