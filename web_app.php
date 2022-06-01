<html>
    <head>
        <title>CS340 Final</title>
    </head>
    <body>
        <h1>CS 340 Final Project</h1>
        <h2>Seth Weiss and Orion Junkins</h2>
        <h2>Spring 2022</h2>
        <!-- insert description of web page here/user instructions -->
        <?php 
            $db = new SQLite3('server.db');
            $lines = file_get_contents("Junkins_Weiss_FinalProject_SQLSchema.sql");
            $db->exec($lines);

            $sql = "SELECT * FROM Agency";
            $result = $db->query($sql);
            if ($result->num_rows > 0) {            // output data of each row
                while ( $row = $result->fetch_assoc()) {
                    echo "<br>agency_id:" . $row["agency_id"] . " - " .
                        " agency_name:" . $row["agency_name"];
                }
            } else {
                echo "NO RESULTS";
            }
            
        ?> 
    </body>
    <footer>
        <p>© 2022 Seth Weiss and Orion Junkins</p>
    </footer>
</html>