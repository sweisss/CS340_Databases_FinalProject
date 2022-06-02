<html>
    <head>
        <title>CS340 Final</title>
    </head>
    <body>
        <h1>CS 340 Final Project</h1>
        <h2>Seth Weiss and Orion Junkins</h2>
<<<<<<< Updated upstream
        <h2>Spring 2022</h2>
        <!-- insert description of web page here/user instructions -->
=======
        <form action="web_app.php" method="post">
            <div>
                <label for="query">Query:</label>
                <input type="query" id="query" name="query" />
            </div>
            <button type="submit">Submit</button>
        </form>

>>>>>>> Stashed changes
        <?php 
            $db = new SQLite3('server.db');
            $lines = file_get_contents("Junkins_Weiss_FinalProject_SQLSchema.sql");
            $db->exec($lines);

            if (isset($_POST['query'])) {
                $sql = $_POST['query'];
            } else {
                
                echo "<br>Please input a query</br>";
            }

            $res = $db->query($sql);              
            while ($row = $res->fetchArray()) {
                echo "<br>";
                echo $row[0];
                echo "    |    ";
                echo $row[1];
                echo "    |    ";
                echo $row[2];
                echo "    |    ";
                echo $row[3];
                // foreach ($row as $val){
                //     echo $val;
                //     echo " | ";
                // }
                echo "</br>";
                
            }


            
        ?> 
    </body>
    <footer>
        <p>© 2022 Seth Weiss and Orion Junkins</p>
    </footer>
</html>