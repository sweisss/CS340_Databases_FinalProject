<!-- CS340 Databases
Spring 2022
Final Project - SQL Schema Part 6: User-Interface
Seth Weiss, Orion Junkins
weissse@oregonstate.edu
junkinso@oregonstate.edu -->

<html>
<?php 
    // Create a new database named server.db
    $db = new SQLite3('server.db');

    // Load sql commands for building and populated the db
    $build_db_commands = file_get_contents("schema.sql");
    
    // Execute build commands
    $db->exec($build_db_commands);

    // Define a core function that, given an sql query and a database instance, will:
    // - Query the db
    // - Fetch results
    // - Render an html table to show the results
    function build_table($sql, $db) {
        echo "Results shown for query:  ";
        echo $sql;

        // Send the loaded query to the db
        $res = $db->query($sql);     
        
        // Start building the result table
        echo "<table style=\"width:100%\">";
        
        // Build the Header by fetching each column name
        echo "<tr>";
        $numColumns = $res->numColumns();
        for ($i = 0; $i < $numColumns; $i++) 
        {
            echo "<td>";
            $header = $res->columnName($i);
            echo $header;
            echo "</td>";
        }
        echo "</tr>";

        // Iterate through all rows in the result to build each table row
        while ($row = $res->fetchArray()) {
            echo "<tr>";

            for ($i = 0; $i < $numColumns; $i++) {
                echo "<td>";
                echo $row[$i];
                echo "</td>";
            }
            echo "</tr>";
        }

        // Conclude the table
        echo "</table>";
      }
?>
    <style>
    table, th, td {
    border:1px solid black;
    }
    </style>
    <head>
        <title>CS340 Final</title>
    </head>
    <body>
         <!-- Header info/text -->
        <h1>CS 340 Final Project</h1>
        <h2>Seth Weiss and Orion Junkins</h2>
        <h2>Spring 2022</h2>
        <p>Enter a custom query or select a pre-canned query from below.<p>

        <!-- Build a text box with a submit button -->
        <!-- On submit, a post request is sent to web_app.php -->
        <!-- Entered text will be sent with the label 'query' -->
        <form action="web_app.php" method="post">
            <div>
                <label for="query">Custom Query:</label>
                <input type="query" id="query" name="query" />
            </div>
            <button type="submit">Submit</button>
        </form>

        <?php 
            // Get the query specified and build a table
            if (isset($_POST['query'])) {
                $sql = $_POST['query'];
                build_table($sql, $db);
            } else if (isset($_POST['canned_query_1'])) {
                $sql = "SELECT a.agency_name, p.problem_type, COUNT(p.problem_type) FROM Forecast as fr INNER JOIN Problem as p ON fr.fid = p.fid INNER JOIN Agency as a ON fr.issued_by = a.agency_id WHERE issued_by=1 GROUP BY p.problem_type ORDER BY COUNT (p.problem_type) DESC LIMIT 1;";
                
                
                build_table($sql, $db);
            } else if (isset($_POST['canned_query_2'])) {
                $sql = "SELECT DISTINCT p.pid ,fr.issue_date, ag.agency_name, fr.corresponds_to as Zone, p.problem_type, p.size, p.likelihood, a.aspect, e.elevation FROM Forecast as fr JOIN Problem as p ON fr.fid = p.fid JOIN Aspect as a  ON p.pid = a.pid JOIN Elevation as e  ON p.pid = e.pid JOIN Forecaster as f ON fr.issued_by = f.frcstr_id JOIN Agency as ag ON ag.agency_id = f.agency_id WHERE a.aspect = \"E\" AND ag.agency_id=6 LIMIT 5;";                 
                
                
                build_table($sql, $db);
            } else if (isset($_POST['canned_query_3'])) {
                $sql = "SELECT fid, issue_date, danger_below_treeline, danger_at_treeline, danger_above_treeline, issued_by as Agency, corresponds_to AS Zone, pid, problem_type, size, likelihood FROM Forecast  NATURAL JOIN Problem  WHERE problem.problem_type = \"Wind Slab\" ORDER BY corresponds_to, issue_date LIMIT 5;";
                
                
                build_table($sql, $db);
            } else if (isset($_POST['canned_query_4'])) {
                $sql = "SELECT DISTINCT o.observation_date, z.zone_name, o.observation_location, CASE WHEN avalanche = 0 THEN 'No' ELSE 'Yes' END AS avalanche, o.obs_description  FROM Observation AS o NATURAL JOIN Zone AS z NATURAL JOIN Agency AS a  WHERE agency_id IN (0, 3) LIMIT 5;";
                
                
                build_table($sql, $db);
            } else if (isset($_POST['canned_query_5'])) {
                $sql = "SELECT f.fname, f.lname FROM Forecaster AS f LEFT JOIN Observer AS o ON f.fname = o.fname WHERE o.fname IS NULL; ";
    

                build_table($sql, $db);
            } else {
                echo "<br>Please input a query</br>";
            }            
        ?> 

         <!-- List several buttons/descriptions for precanned queries-->
        <h2>Precanned Queries</h2>

        <!-- Query 1 -->
        <form method="post">
            <h4>Canned Query 1: Find the most common avalanche problem in Utah.</h4>
            <p> Identify the single most common type of problem from all forecasts issued by forecasters who work for the Utah Avalanche Center (agency_id=1). Return the agency name, the problem type, and the total count identified.</p> 
            
            <p>SELECT a.agency_name, p.problem_type, COUNT(p.problem_type) <br>FROM Forecast as fr <br>INNER JOIN Problem as p <br>ON fr.fid = p.fid <br>INNER JOIN Agency as a <br>ON fr.issued_by = a.agency_id <br>WHERE issued_by=1 <br>GROUP BY p.problem_type <br>ORDER BY COUNT (p.problem_type) DESC <br>LIMIT 1;</p>
            <input type='submit' name="canned_query_1" value="Submit Query 1"><br>
        </form>
        
        <!-- Query 2 -->
        <form method="post">
            <h4>Canned Query 2: Search forecasts from Colorado (agency id of 6) which have a problem on an eastern aspect and return an overview of each problem.  </h4>
            
            <p>SELECT DISTINCT p.pid ,fr.issue_date, ag.agency_name, fr.corresponds_to as Zone, p.problem_type, p.size, p.likelihood, a.aspect, e.elevation <br>FROM Forecast as fr <br>JOIN Problem as p <br>ON fr.fid = p.fid <br>JOIN Aspect as a  <br>ON p.pid = a.pid <br>JOIN Elevation as e  <br>ON p.pid = e.pid <br>JOIN Forecaster as f <br>ON fr.issued_by = f.frcstr_id <br>JOIN Agency as ag <br>ON ag.agency_id = f.agency_id <br>WHERE a.aspect = "E" AND ag.agency_id=6 <br>LIMIT 5;</p>
            <input type='submit' name="canned_query_2" value="Submit Query 2"><br>
        </form>
        

        <!-- Query 3 -->
        <form method="post">
            <h4>Canned Query 3: Find all forecasts that involve a Wind Slab problem. Order first by zone (corresponds_to) then by issue date.  </h4>
            
            <p>SELECT fid, issue_date, danger_below_treeline, danger_at_treeline, danger_above_treeline, issued_by as Agency, corresponds_to AS Zone, pid, problem_type, size, likelihood <br>FROM Forecast  <br>NATURAL JOIN Problem  <br>WHERE problem.problem_type = "Wind Slab" <br>ORDER BY corresponds_to, issue_date <br>LIMIT 5;</p>
            <input type='submit' name="canned_query_3" value="Submit Query 3"><br>
        </form>


        <!-- Query 4 -->
        <form method="post">
            <h4>Canned Query 4: Find all observation data from Oregon.</h4>
            
            <p>SELECT DISTINCT  <br>    o.observation_date,  <br>    z.zone_name,  <br>    o.observation_location, <br>    CASE WHEN avalanche = 0 THEN 'No' ELSE 'Yes' END AS avalanche,  <br>    o.obs_description  <br>FROM Observation AS o <br>NATURAL JOIN Zone AS z <br>NATURAL JOIN Agency AS a  <br>WHERE agency_id IN (0, 3) <br>LIMIT 5;</p>
            <input type='submit' name="canned_query_4" value="Submit Query 4"><br>
        </form>


        <!-- Query 5 -->
        <form method="post">
            <h4>Canned Query 5: Find the first and last name of forecasters who have not contributed an observation.</h4>
            
            <p>SELECT f.fname, f.lname FROM Forecaster AS f LEFT JOIN Observer AS o ON f.fname = o.fname WHERE o.fname IS NULL; <br></p>
            <input type='submit' name="canned_query_5" value="Submit Query 5"><br>
        </form>


    </body>
    <footer>
        <p>© 2022 Seth Weiss and Orion Junkins</p>
    </footer>
</html>