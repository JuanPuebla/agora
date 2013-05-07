<?php

// TODO: Review strings (some of them are directly here instead of in the lang file.



function import19_restore($filename, $courseid = false, $categoryid = false) {
    global $OUTPUT, $CFG, $DB, $USER, $agora;

    require_once($CFG->dirroot . '/backup/util/includes/backup_includes.php');
    require_once($CFG->dirroot . '/backup/moodle2/backup_plan_builder.class.php');
    require_once($CFG->dirroot . '/backup/util/includes/restore_includes.php');
    require_once($CFG->dirroot . '/backup/util/ui/import_extensions.php');
    require_once($CFG->dirroot . '/backup/util/output/output_controller.class.php');

    // Aesthetic improvement
    echo $OUTPUT->spacer();
    echo $OUTPUT->spacer();

    $tmpdir = $CFG->tempdir . '/backup';
    if (!check_dir_exists($tmpdir, true, true)) {
        print_error('El directori temporal ' . $tmpdir . ' no es pot escriure');
    }

    $origin = $CFG->dataroot . $agora['moodle2']['repository_files'] . $filename;
    if (!file_exists($origin)) {
        // The name of the backup created is different from the one specified so it's necessary to search the correct one
        $filenamestart = substr($filename, 0, strrpos($filename, '-', -1));
        $origin = exec('ls ' . $CFG->dataroot . $agora['moodle2']['repository_files'] . $filenamestart . '-*');
    }

    $userid = $USER->id;

    $fb = get_file_packer();
    $filepath = restore_controller::get_tempdir_name($courseid, $userid);
    if (!$fb->extract_to_pathname($origin, "$tmpdir/$filepath/")) {
        print_error('No es pot descomprimir el fitxer ' . $origin);
    }

    try {
        if (!$courseid) {
            // Create importing category
            if (!$restorecat = $DB->get_field('course_categories', 'id', array('id' => $categoryid))) {
                $cat = new StdClass();
                $cat->name = 'Moodle 1.9';
                $cat->description = "Cursos traspassats del Moodle 1.9 d'Àgora";
                $cat->parent = 0;
                $cat->sortorder = 0;
                $cat->visible = 0;
                $cat->depth = 1;

                $restorecat = $DB->insert_record('course_categories', $cat);
                $DB->set_field('course_categories', 'path', '/' . $restorecat, array('id' => $restorecat));

                echo $OUTPUT->notification('S\'ha creat la categoria \'' . $cat->name . '\'', 'notifysuccess');
            }

            // Create new course
            $target = backup::TARGET_NEW_COURSE;
            list($fullname, $shortname) = restore_dbops::calculate_course_names(0, get_string('restoringcourse', 'backup'), get_string('restoringcourseshortname', 'backup'));
            $courseid = restore_dbops::create_new_course($fullname, $shortname, $restorecat);
            echo $OUTPUT->notification('S\'ha creat el curs', 'notifysuccess');
        } else {
            $target = backup::TARGET_EXISTING_ADDING;
            echo $OUTPUT->notification('El curs ja existeix. S\'hi afegeix la informació', 'notifysuccess');
        }

        $transaction = $DB->start_delegated_transaction();
        // Restore backup into course
        $controller = new restore_controller($filepath, $courseid,
                        backup::INTERACTIVE_NO, backup::MODE_IMPORT, $userid, $target);
        if ($controller->get_status() == backup::STATUS_REQUIRE_CONV) {
            echo $OUTPUT->notification('Convertint des del Moodle 1.9', 'notifysuccess');
            $controller->convert();
        }
        if ($controller->get_status() == backup::STATUS_SETTING_UI) {
            $controller->finish_ui();
        }
        $controller->execute_precheck();
        $controller->execute_plan();
        // Commit
        $transaction->allow_commit();
    } catch (Exception $e) {
        print_error('No s\'ha pogut importar el curs ' . $e->getMessage());
    }

    echo $OUTPUT->notification('La importació ha finalitzat correctament', 'notifysuccess');

    $courseurl = new moodle_url('/course/view.php', array('id' => $courseid));

    // Remove the backup after restoring in order to save quota
    if (unlink($CFG->dataroot . $agora['moodle2']['repository_files'] . $filename)) {
        echo $OUTPUT->notification('S\'ha esborrat la còpia de seguretat temporal (<em>' . $filename . '</em>) utilitzada per fer la importació', 'notifysuccess');
    }

    echo $OUTPUT->spacer();
    echo $OUTPUT->spacer();

    echo $OUTPUT->continue_button($courseurl);
    return true;
}

/**
 * Called from backup/restorefile.php to show the courses in Moodle 1.9
 * @global type $CFG
 * @global type $USER
 * @global type $OUTPUT
 * @global type $PAGE
 * @global type $agora
 * @global type $school_info
 * @param type $contextid
 * @return type
 */
function import19_course_selector($contextid) {
    global $CFG, $USER, $OUTPUT, $PAGE, $agora, $school_info;

    $html = '';
    $dbconn = import19_connect_moodle19_db();

    if ($dbconn) {
        // Look for the user in Moodle 1.9 tables
        $user19 = $dbconn->get_record('user', array('username' => $USER->username));
        if (empty($user19)) {
            // If user not found, look for the idnumber
            $user19 = $dbconn->get_record('user', array('idnumber' => $USER->idnumber));
        }
        if (is_siteadmin() || !empty($user19)) {
            // If $user19 not empty, get user role in Moodle 1.9
            if (!empty($user19)) {
                $sql = "SELECT count(*) AS total FROM {role} r, {role_assignments} ra WHERE r.shortname='admin' AND r.id=ra.roleid AND ra.contextid=1 AND ra.userid=$user19->id";
                $isadmin19 = $dbconn->get_field_sql($sql) == 1;
            }

            // Get list of courses which can be restored by the current user
            $courses = array();

            if (is_siteadmin() || $isadmin19) {
                // If the user is admin in 1.9, can access the full list of courses
                $sql = "SELECT c.id, c.shortname, c.fullname, cat.name AS catname, cat.parent AS catparent
                                    FROM {course} c, {course_categories} cat
                                    WHERE cat.id = c.category ORDER BY cat.parent DESC";

                $courses = $dbconn->get_records_sql($sql);
            } else if ($user19) {
                // get_records_sql() does not accept ':' in SQL, so this is a workaround
                $caps = array();
                $sql = "SELECT id, capability FROM {role_capabilities}";

                $capabilities = $dbconn->get_records_sql($sql);

                foreach ($capabilities as $capability) {
                    if ($capability->capability == 'moodle/site:backup')
                        $caps[] = ' rc.id=' . $capability->id . ' ';
                }

                $capabilities = (!empty($caps)) ? '(' . implode('OR', $caps) . ') AND ' : '';

                // Get the category list where user has backup capability (category level role)
                $sql = "SELECT distinct cat.id as catid, cat.name as catname, cat.parent as catparent
                        FROM {course_categories} cat
                        LEFT JOIN {context} ctx ON cat.id = ctx.instanceid
                        LEFT JOIN {role_assignments} ra ON ctx.id = ra.contextid
                        LEFT JOIN {role_capabilities} rc ON rc.roleid = ra.roleid
                        WHERE $capabilities
                        ctx.contextlevel=40
                        AND ra.userid=$user19->id
                        ORDER BY cat.parent DESC";

                $categories = $dbconn->get_records_sql($sql);

                // Get the courses in those categories
                foreach ($categories as $category) {
                    
                    // Get the subcategories
                    $subcategories = agora_import19_getSubcategories($dbconn, $category->catid);

                    // Add current category to subcategories (ok, it's not really a subcategory, but...)
                    $subcategories[$category->catid] = array('catid' => $category->catid, 'catname' => $category->catname, 'catparent' => $category->catparent);

                    // Get the courses of all the categories
                    foreach ($subcategories as $cat) {
                        $sql = "SELECT c.id, c.shortname, c.fullname, '$cat[catname]' as catname, '$cat[catparent]' as catparent
                                FROM {course} c
                                WHERE c.category = $cat[catid]
                                ORDER BY c.category DESC";

                        $courses += $dbconn->get_records_sql($sql);
                    }
                }

                // Get the course list where user has backup capability (course level role)
                $sql = "SELECT distinct c.id, c.shortname, c.fullname, cat.name as catname, cat.parent as catparent
                        FROM {course} c
                        LEFT JOIN {course_categories} cat ON c.category = cat.id
                        LEFT JOIN {context} ctx ON c.id = ctx.instanceid
                        LEFT JOIN {role_assignments} ra ON ctx.id = ra.contextid
                        LEFT JOIN {role_capabilities} rc ON rc.roleid = ra.roleid
                        WHERE $capabilities
                        ctx.contextlevel=50
                        AND ra.userid=$user19->id
                        ORDER BY cat.parent DESC";

                // Union of arrays: merge removing duplicates
                $courses += $dbconn->get_records_sql($sql);

                if (empty($courses)) {
                    echo "<br/>Aquest usuari/ària no té accés a cap curs";
                }
            }

            $categories = array();

            if ($courses) {
                // Create table
                $shortnamestr = get_string('shortname');
                $fullnamestr = get_string('fullname');
                $categorystr = get_string('category');

                $table = new html_table();
                $table->head = array('', $shortnamestr, $fullnamestr, $categorystr);
                $table->align = array('left', 'left', 'left', 'left');
                $table->width = '90%';

                $cat2form = array();

                foreach ($courses as $course) {
                    $catname = $course->catname;
                    $parent = $course->catparent;

                    while ($parent > 0) {
                        if (!isset($categories[$parent])) {
                            $cat = $dbconn->get_record('course_categories', array('id' => $parent), 'name, parent');
                            if ($cat) {
                                $categories[$parent] = new StdClass();
                                $categories[$parent]->name = $cat->name;
                                $categories[$parent]->parent = $cat->parent;
                            } else {
                                $categories[$parent] = new StdClass();
                                $categories[$parent]->name = '';
                                $categories[$parent]->parent = 0;
                            }
                        }
                        if (!empty($categories[$parent]->name)) {
                            $catname = $categories[$parent]->name . ' ► ' . $catname;
                        }
                        $parent = $categories[$parent]->parent;
                    }

                    if (isset($catname)) {
                        $checkbok = "<input type='radio' value='$course->id' name='importid'>";
                        $url = $CFG->wwwroot19 . '/course/view.php?id=' . $course->id;
                        $table->data[] = array($checkbok,
                            '<a href="' . $url . '" target="_blank">' . $course->shortname . '</a>',
                            $course->fullname,
                            $catname
                        );
                    }
                }

                $html .= html_writer::start_tag('div', array('class' => 'import-course-selector backup-restore'));
                $html .= html_writer::start_tag('div', array('class' => 'import19 backup-section'));
                
                $html .= html_writer::start_tag('form', array('method' => 'post', 'action' => $CFG->wwwroot . '/local/agora/import19/bridge.php'));

                $html .= html_writer::start_tag('div', array('class' => 'detail-pair'));
                $html .= html_writer::tag('label', get_string('selectacourse', 'backup'), array('class' => 'detail-pair-label'));
                $html .= html_writer::start_tag('div', array('class' => 'detail-pair-value'));
                $html .= html_writer::tag('div', get_string('totalcoursesearchresults', 'backup', count($courses)));
                
                $html .= html_writer::table($table);
              
                $html .= html_writer::empty_tag('input', array('type' => 'hidden', 'name' => 'contextid', 'value' => $contextid));
                $html .= html_writer::empty_tag('input', array('type' => 'hidden', 'name' => 'sesskey', 'value' => sesskey()));
                $html .= html_writer::empty_tag('input', array('type' => 'submit', 'value' => get_string('continue')));
                $html .= html_writer::end_tag('div');
                $html .= html_writer::end_tag('div');

                $html .= html_writer::end_tag('form');

                $html .= html_writer::end_tag('div');
                $html .= html_writer::end_tag('div');

                // Close the DB connection
                $dbconn->dispose();
            }
        } else {
            // Close the DB connection
            $dbconn->dispose();

            return $OUTPUT->notification(get_string('import19_nocourses', 'local_agora'));
        }
    } else {
        return $OUTPUT->notification(get_string('import19_nodbconnect', 'local_agora'));
    }

    return $html;
}

/**
 * Connect to Moodle 1.9 database
 * 
 * @global object $DB
 * @global object $CFG
 * @global array $agora
 * @return db handler 
 */
function import19_connect_moodle19_db() {
    global $DB, $CFG, $agora;

    $library = 'native';
    if (!$handler = moodle_database::get_driver_instance($CFG->dbtype, $library, true)) {
        throw new dml_exception('dbdriverproblem', "Unknown driver $library/" . $CFG->dbtype);
    }

    try {
        if (is_agora()) {
            $handler->connect($agora['moodle']['dbhost'], $CFG->dbuser, $agora['moodle']['userpwd'], $CFG->dbname, $agora['moodle']['prefix'], $CFG->dboptions);
        } else {
            $handler->connect($agora['moodle']['dbhost'], $agora['moodle']['user'], $agora['moodle']['userpwd'], $agora['moodle']['dbname'], $agora['moodle']['prefix'], $CFG->dboptions);
        }
    } catch (moodle_exception $e) {
        echo 'Caught exception: ', $e->getMessage();
        return false;
    }
    return $handler;
}

/**
 * Creates a tree data structure wich contains, only, category information. Iterates
 *  recursively.
 *
 * @author Toni Ginard (aginard@xtec.cat)
 * @param array $dbRecords Contains all the categories info from the data base
 * @param int $catID ID of the category where to start
 * @param int $depth Level of the category being processed. Avoids processing subcategories.
 *
 * @return array Tree with data (see description)
 */
function agora_import19_buildCatTree($dbRecords, $catID, $depth) {
    
   $catTree = array();
    
    // First pass to get categories whose parent is this category (aka subcategories)
    foreach ($dbRecords as $key => $record) {
        if ($record->parent == $catID) {
            $catTree[$record->id] = array('Id' => $record->id, 'Name' => $record->name, 'Subcategories' => array(), 'categorysize' => 0);
            // Effiency improvement: Once the category is added to the tree, it won't be added again
            unset($dbRecords[$key]);
        }
    }
    
    // Second pass for recursive call for all the categories in this category. The process
    //  can't be done in a single pass because we only have the full list of categories 
    //  of this depth once we have completed the first pass.
    foreach ($catTree as $cat) {
        foreach ($dbRecords as $record) {
            // Condition 1: next level of depth
            // Condition 2: the category must be under the current category
            if (($record->parent == $cat['Id'])) {
                $catTree[$cat['Id']]['Subcategories'] = agora_import19_buildCatTree($dbRecords, $cat['Id'], $depth + 1);
            }
        }
    }

    return $catTree;
}

/**
 * Transforms category tree in a string HTML-formatted to be sent to the browser.
 *  Builds a list with category information
 *
 * @author Toni Ginard (aginard@xtec.cat)
 * @param array $data Category tree
 *
 * @return string HTML code to be sent to the browser
 */
function agora_import19_printCategoryData($data, $padding = 0) {
    
    foreach ($data as $category) {

        // Build list content
        $content .= html_writer::start_tag('li', array('style' => 'padding: 5px;' . ' padding-left:' . $padding . 'px'));
        $content .= html_writer::empty_tag('input', array('type' => 'radio', 'name' => 'categoryid', 'value' =>$category['Id']));
        $content .= html_writer::tag('span', $category['Name']);
        $content .= html_writer::end_tag('li');

        // Recursive call for subcategories
        if (!empty($category['Subcategories'])) {
            $content .= agora_import19_printCategoryData($category['Subcategories'], $padding + 10);
        }
    }

    return $content;
}

/**
 * Build an array with the current category and its subcategories. Uses database
 * connection to Moodle 1.9
 * 
 * @param handler $dbconn
 * @param int $catid
 * @return array 
 */
function agora_import19_getSubcategories($dbconn, $catid) {
    
    $allcategories = array();
    
    // Get categories in this branch and depth level
    $categories = $dbconn->get_records('course_categories', array('parent' => $catid));
    
    // Get subcategories and build result array
    foreach ($categories as $category) {
        // Add current category
        $allcategories[$category->id] = array('catid' => $category->id, 'catname' => $category->name, 'catparent' => $category->parent);
        
        // Get subcategories
        $subcategories = agora_import19_getSubcategories($dbconn, $category->id);
        
        // Default return is 'array()' and that value (empty) must be avoided
        if (!empty($subcategories)) {
            $allcategories += $subcategories;
        }
    }
    
    return $allcategories;
}
