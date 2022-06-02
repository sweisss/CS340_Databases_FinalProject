<html>
    <head>
        <title>CS340 Final</title>
    </head>
    <body>
        <h1>CS 340 Final Project</h1>
        <h2>Seth Weiss and Orion Junkins</h2>
        <h2>Spring 2022</h2>
        <!-- insert description of web page here/user instructions -->

        <!-- Build a text box with a submit button -->
        <!-- On submit, a post request is sent to web_app.php -->
        <!-- Entered text will be sent with the label 'query' -->
        <form action="web_app.php" method="post">
            <div>
                <label for="query">Query:</label>
                <input type="query" id="query" name="query" />
            </div>
            <button type="submit">Submit</button>
        </form>

        <?php 
            // Create aa new database named server.db
            $db = new SQLite3('server.db');

            // Load sql commands for building and populated the db
            $build_db_commands = file_get_contents("Junkins_Weiss_FinalProject_SQLSchema.sql");
            
            // Execute build commands
            $db->exec($build_db_commands);

            // Grab the 'query' value from the POST reqeust if it exists
            if (isset($_POST['query'])) {
                $sql = $_POST['query'];
                // Send the loaded query to the db
                $res = $db->query($sql);     
                

                echo "<br>";
                echo "|    ";
                $numColumns = $res->numColumns();
                for ($i = 0; $i <= $numColumns; $i++) 
                {
                    $header = $res->columnName($i);
                    echo $header;
                    echo "    |    ";
                }
                echo "</br>";
            
                
                // Iterate through all rows in the result
                while ($row = $res->fetchArray()) {
                    echo "<br>";
                    echo "|    ";
                    foreach ($row as $item){
                        echo $item;
                        echo "    |    ";
                    }
                    echo "</br>";
                }
            } else {
                echo "<br>Please input a query</br>";
            }            
        ?> 
    </body>
    <footer>
        <p>© 2022 Seth Weiss and Orion Junkins</p>
    </footer>
</html>