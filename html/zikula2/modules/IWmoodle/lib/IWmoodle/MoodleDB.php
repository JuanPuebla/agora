<?php

class MoodleDB {

    public static function get_connection() {
        global $ZConfig;
        $user = $ZConfig['DBInfo']['databases']['moodle2']['user'];
        $databaseName = $ZConfig['DBInfo']['databases']['moodle2']['dbname'];
        $userpwd = $ZConfig['DBInfo']['databases']['moodle2']['password'];

        $connect = oci_pconnect($user, $userpwd, $databaseName);

        if (!$connect) {
            return LogUtil::registerError('The connection to Moodle database has failed.');
        }
        return $connect;
    }

    public static function get_prefix() {
        return ModUtil::getVar('IWmoodle', 'dbprefix');
    }

    public static function get_records($sql) {
        $connect = self::get_connection();
        if(!$connect) {
            return false;
        }

        $results = self::execute_sql($connect, $sql);
        if (!$results) {
            return false;
        }

        $return = array();
        while ($row = oci_fetch_array($results)) {
            $return[] = self::parse_row($row);
        }
        oci_close($connect);

        return $return;
    }

    public static function get_record($sql) {
        $connect = self::get_connection();
        if(!$connect) {
            return false;
        }

        $results = self::execute_sql($connect, $sql);
        if (!$results) {
            return false;
        }

        $row = oci_fetch_array($results);
        $return = self::parse_row($row);

        oci_close($connect);

        return $return;
    }

    public static function count($sql) {
        $connect = self::get_connection();
        if(!$connect) {
            return false;
        }

        $results = self::execute_sql($connect, $sql);
        if (!$results) {
            return false;
        }

        $array = oci_fetch_row($results);
        oci_close($connect);

        return $array[0];
    }

    public static function exists($sql) {
        return self::count($sql) > 0;
    }

    public static function delete($sql) {
        return self::execute($sql);
    }

    public static function update($sql) {
        return self::execute($sql);
    }

    public static function insert($sql) {
        return self::execute($sql);
    }

    private static function execute($sql) {
        $connect = self::get_connection();
        if(!$connect) {
            return false;
        }

        $results = self::execute_sql($connect, $sql);
        if (!$results) {
            return false;
        }
        oci_close($connect);

        return true;
    }

    private static function execute_sql($connect, $sql) {
        $results = oci_parse($connect, $sql);
        $r = oci_execute($results);
        if (!$r) {
            oci_close($connect);
            return LogUtil::registerError('Error! Could not load items.');
        }
        return $results;
    }

    private static function parse_row($row) {
        $return = array();
        foreach($row as $key => $value) {
            $return[strtolower($key)] = $value;
        }
        return $return;
    }
}