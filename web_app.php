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
                $sql = "SELECT a.agency_name, p.problem_type, COUNT(p.problem_type) FROM Forecast as fr INNER JOIN Problem as p ON fr.fid = p.fid INNER JOIN Agency as a ON fr.issued_by = a.agency_id WHERE issued_by=1 GROUP BY p.problem_type ORDER BY COUNT (p.problem_type) DESC LIMIT 1; ";
                build_table($sql, $db);
            } else if (isset($_POST['canned_query_2'])) {
                $sql = "SELECT agency_id FROM Agency";
                build_table($sql, $db);
            } else if (isset($_POST['canned_query_3'])) {
                $sql = "SELECT danger_at_treeline FROM Forecast";
                build_table($sql, $db);
            } else {
                echo "<br>Please input a query</br>";
            }            
        ?> 

         <!-- List several buttons/descriptions for precanned queries-->
        <h2>Precanned Queries</h2>
        <form method="post">
            <h4>Canned Query 1: SELECT a.agency_name, p.problem_type, COUNT(p.problem_type)
FROM Forecast as fr
INNER JOIN Problem as p
ON fr.fid = p.fid
INNER JOIN Agency as a
ON fr.issued_by = a.agency_id
WHERE issued_by=1
GROUP BY p.problem_type
ORDER BY COUNT (p.problem_type) DESC
LIMIT 1; </h4>
            <input type='submit' name="canned_query_1" value="Submit Query 1"><br>
        </form>
        <form method="post">
            <h4>Canned Query 2: SELECT agency_id FROM Agency</h4>
            <input type='submit' name="canned_query_2" value="Submit Query 2"><br>
        </form>
        <form method="post">
            <h4>Canned Query 3: SELECT danger_at_treeline FROM Forecast</h4>
            <input type='submit' name="canned_query_3" value="Submit Query 2"><br>
        </form>
    </body>
    <footer>
        <p>© 2022 Seth Weiss and Orion Junkins</p>
    </footer>
</html>