    <?php
		include 'db_connection_test.php';
		if (isset($_SERVER['HTTP_ORIGIN'])){
          header("Access-Control-Allow-Origin: *"); # Allow all external connections
          header("Access-Control-Max-Age: 60"); # Keep connections open for 1 minute

          # Check if a site is requesting access to the site:
          if ($_SERVER["REQUEST_METHOD"] === "OPTIONS"){
              header("Access-Control-Allow-Methods: POST, OPTIONS"); # Only allow these kinds of connections
              header("Access-Control-Allow-Headers: Authorization, Content-Type, Accept, Origin, cache-control");
              http_response_code(200); # Report that they are good to make their request now
              die; # Quit here until they send a followup!
          }
		}

		$sql_host = "mysql44.unoeuro.com";
        $sql_db = "spaghetticodestudios_com_db";
        $sql_username = "spaghetticodestudios_com";
        $sql_password = "mF2nAR3wDrE6fkt4echd";
		
		$dsn = "mysql:dbname=$sql_dn;host=$sql_host;charset=utf8mb4;port=3306";
        $pdo = null;

        # Attempt to connect:
        try{
            $pdo = new PDO($dsn, $sql_username, $sql_password);
        }
		catch (\PDOException $e){
		print_response([], "db_login_error");
		die;
	}

		if ($_SERVER['REQUEST_METHOD'] !== "POST"){
          http_response_code(405); # Report that they were denied access
          die; # End things here.
		}
		#Returns information and data to Godot
		function print_response($datasize, $dictionary = [], $error = "none"){
			$string = "{\"error\" : \"$error\",
						\"command\" : \"$_REQUEST[command]\",
						\"datasize\" : $datasize,
						\"response\" : ". json_encode($dictionary) ."}";
						
			#Print out json to Godot
			echo $string;
		}
		
		
		
		#Handle error: 
		#Missing command
		if (!isset($_REQUEST['command']) or $_REQUEST['command'] === null){
			//print_response([], "missing_command");
			echo "{\"error\":\"missing_command\",\"response\":{}}";
			die; 
		}
		
		#Missing data
		if (!isset($_REQUEST['data']) or $_REQUEST['data'] === null){
			print_response([], "missing_data");
			die;
		}
		
		
		
		#Convert Godot json to dictionary
		$dict_from_json = json_decode($_REQUEST['data'], true);
		#var_dump($dict_from_json);
		#echo $dict_from_json["score"];
		#die;
		
		#Is dictionary valid
		if ($dict_from_json === null){
			print_response([], "invalid_json");
			die;
		}
		function verify_nonce($pdo, $secret = "1234567890"){
            # Make sure they sent over a CNONCE:
            if (!isset($_SERVER['HTTP_CNONCE'])){
                print_response([], "invalid_nonce");
                return false;
            }

            # Make a request to pull the nonce from the server:
            $template = "SELECT nonce FROM `nonces` WHERE ip_address = :ip";
            $sth = $pdo -> prepare($template);
            $sth -> execute(["ip" => $_SERVER['REMOTE_ADDR']]);
            $data = $sth -> fetchAll(PDO::FETCH_ASSOC);

            # Check that there was a nonce for this user on the server:
            if (!isset($data) or sizeof($data) <= 0){
                print_response([], "server_missing_nonce");
                return false;
            }

            # Delete the nonce off the server. Each is a one-use key:
            $sth = $pdo -> prepare("DELETE FROM `nonces` WHERE ip_address = :ip");
            $sth -> execute(["ip" => $_SERVER["REMOTE_ADDR"]]);

            # Check the nonce hash to make sure it is valid:
            $server_nonce = $data[0]['nonce'];

            if (hash('sha256', $server_nonce . $_SERVER['HTTP_CNONCE'] . file_get_contents("php://input") . $secret) != $_SERVER["HTTP_HASH"]){
                print_response([], "invalid_nonce_or_hash");
                return false;
            }

            # At this point, all is good!
            return true;
		}
		switch ($_REQUEST['command']){
			
			#Adding score
			case "add_score":
				
				#Handle error for add score
				if (!isset($dict_from_json['score'])){
					print_response([], "missing_score");
					die;
				}
								
				if (!isset($dict_from_json['username'])){
					print_response([], "missing_username");
					die;
				}
            	if (!isset($dict_from_json['level'])){
					print_response([], "missing_level");
					die;
				}
            	
				
            
				# Username max length 40, -> should be handled in Godot
				$username = $dict_from_json['username'];
            	
				if (strlen($username) > 40)
					$username = substrt($username, 40);
				
				$score = $dict_from_json['score'];
				$level = $dict_from_json['level'];
				
            
				#Make a connection to the DB
				$conn = OpenCon();
				
				// Check connection
				if ($conn->connect_error) {
					print_response("0", [], "db_login_error");
					die();
				}
				
            	$sql = "SELECT ID FROM User WHERE username = ?";
                $stmt = $conn->prepare($sql);
                $stmt->bind_param("s", $username);
                $stmt->execute();
                $stmt->bind_result($user_id);
                $stmt->fetch();

                // Close statement and database connection
                $stmt->close();
                
            
				#Create sql to pass to DB
				$sql = "INSERT INTO UserScore (User_ID_FK,level, value) VALUES (?, ?, ?) ON 
                DUPLICATE KEY UPDATE value = GREATEST(value, VALUES(value));";
				
				// prepare and bind
				$stmt = $conn->prepare($sql);
				#s:string, i:integer, d:decimal(float), b:blob
				$stmt->bind_param("iii", $user_id,$level, $score);
				
				
				#DB call 
				$stmt->execute();
				
				#Close statement and connection
				$stmt->close();				
				CloseCon($conn);
				
				#Response to Godot, all is fine
				print_response("0", []);
				die;
				
			break;
			
            case "add_user":
				
				#Handle error for add score
				if (!isset($dict_from_json['password'])){
					print_response([], "missing_password");
					die;
				}
								
				if (!isset($dict_from_json['username'])){
					print_response([], "missing_username");
					die;
				}
            	
				
            
				# Username max length 40, -> should be handled in Godot
				$username = $dict_from_json['username'];
            	$password = hash('sha256', $dict_from_json['password']);
            	
				if (strlen($username) > 40)
					$username = substrt($username, 40);
				
				
				#Make a connection to the DB
				$conn = OpenCon();
				
				// Check connection
				if ($conn->connect_error) {
					print_response("0", [], "db_login_error");
					die();
				}
				
				#Create sql to pass to DB
				$sql = "INSERT INTO User (username, password) VALUES (?, ?);";
				// prepare and bind
				$stmt = $conn->prepare($sql);
				#s:string, i:integer, d:decimal(float), b:blob
				$stmt->bind_param("ss", $username, $password);
				
				
				#DB call 
				try {
					$success = $stmt->execute();
                      if ($success) {
                          // Bruger tilføjet
                          print_response("0", [],"");
                      } else {
                          // Kunne ikke tilføje bruger (nok pga. UNIQUE begrænsning på brugernavn kollonen)
               
                          print_response("0", [],"sameusername");
                      }
                  
                } catch (Throwable $e) {
                  echo "dahel";
                  print_response("0", [],"sameusername");
                }
            	                
				
            
				#Close statement and connection
				$stmt->close();				
				CloseCon($conn);
				
				#Response to Godot, all is fine
				
				die;
				
			break;
          	
          	case "get_player_progress":
            	
        		$username=$dict_from_json['username'];
            
            	if (strlen($username) > 40)
					$username = substrt($username, 40);
            
            
            	
                
				#Make a connection to the DB
				$conn = OpenCon();
				
				// Check connection
				if ($conn->connect_error) {
					print_response([], "db_login_error");
					die();
				}
                
			
				
				$sql = "SELECT UserScore.value FROM User JOIN UserScore ON UserScore.User_ID_FK=User.ID WHERE User.username=?";
			
				// prepare and bind
				$stmt = $conn->prepare($sql);
				#s:string, i:integer, d:decimal(float), b:blob
				$stmt->bind_param("s",$username);
				
				#DB call 
				$stmt->execute();
				
				$result = $stmt->get_result();
				$players;
				if ($result->num_rows > 0) {
                // Fetch all rows into an array
                $players = $result->fetch_all(MYSQLI_ASSOC);

                // Get the length of the result array
                $length = count($players);

                // Output the length
                

                // Loop through the rows
                
            } else {
                
                 $length=0;
            }
				#$players["size"] = $counter;
				
				#Close result, statement and connection
				$result->close();
				$stmt->close();				
				CloseCon($conn);
				
				#$players["size"] = sizeof($players);
				
				print_response($length,$players, "");
				die;
            
            	
           	break;
            case "get_level_scores":
				$score_number_of = 5;
				
            
            	
            
				if (isset($dict_from_json['score_number']))
					$score_number_of = max(1, (int)$dict_from_json['score_number']);
				
            	if (strlen($username) > 40)
					$username = substrt($username, 40);
            
            
            	
                $level=$dict_from_json['level'];
				#Make a connection to the DB
				$conn = OpenCon();
				
				// Check connection
				if ($conn->connect_error) {
					print_response([], "db_login_error");
					die();
				}
            
  
                
			
				
				$sql = "SELECT * FROM UserScore JOIN User ON UserScore.User_ID_FK=User.ID WHERE level=? ORDER BY value DESC LIMIT ?";
				//$sql = "SELECT * FROM players WHERE id = ?;";
			
				// prepare and bind
				$stmt = $conn->prepare($sql);
				#s:string, i:integer, d:decimal(float), b:blob
				$stmt->bind_param("ii",$level, $score_number_of);
				
				#DB call 
				$stmt->execute();
				
				$result = $stmt->get_result();
				$players;
				$player = $result->fetch_array(MYSQLI_ASSOC);
				$counter = 0;
				while ($player != null)
				{
					//$players = json_decode($players, TRUE);
					$players[] = $player;
					$player = $result->fetch_array(MYSQLI_ASSOC);
					$counter++;
				} 
				#$players["size"] = $counter;
				$players["dummy"] = "";
				$players = json_encode($players);
				
				#Close result, statement and connection
				$result->close();
				$stmt->close();				
				CloseCon($conn);
				
				#$players["size"] = sizeof($players);
				
				print_response($counter, $players);
				die;
			
			
			break;
            
          	case "get_nonce":
                # Generate random bytes that we can hash:
                $bytes = random_bytes(32);
                $nonce = hash('sha256', $bytes);

                # Form our SQL template:
                $template = "INSERT INTO `nonces` (ip_address, nonce) VALUES (:ip, :nonce) ON DUPLICATE KEY UPDATE nonce = :nonce_update";

                # Prepare and send via PDO:
                $sth = $pdo -> prepare($template);
                $sth -> execute(["ip" => $_SERVER["REMOTE_ADDR"], "nonce" => $nonce, "nonce_update" => $nonce]);
				
                # Send the nonce back to Godot:
                print_response(1,["nonce" => $nonce],"");

                die;
			break;
          	case "get_player_username":
            	
				#Handle missing user id
				if (!isset($dict_from_json['username'])){
					print_response([], "missing_username");
					die;
				}
				
				# Username max length 40, -> should be handled in Godot
				$username = $dict_from_json['username'];
				$password = hash('sha256', $dict_from_json['password']);
				
				
				#Make a connection to the DB
				$conn = OpenCon();
				
				// Check connection
				if ($conn->connect_error) {
					print_response([], "db_login_error");
					die();
				}				
			
				$sql = "SELECT * FROM User WHERE username = ?;";
			
				// prepare and bind
				$stmt = $conn->prepare($sql);
				#s:string, i:integer, d:decimal(float), b:blob
				$stmt->bind_param("s", $username);
				
				#DB call 
				$stmt->execute();
				
				$result = $stmt->get_result();
				$player = $result->fetch_array(MYSQLI_ASSOC);
				
				#Close result, statement and connection
				$result->close();
				$stmt->close();				
				CloseCon($conn);
				
				
				
				#$player["size"] = sizeof($player);
				
				$player["input_password"] = $password;
				print_response(1, $player);
				die;
			
			
			break;
			
				
			
			
			#Handle none excisting request
			default:
				print_response([], "invalide_command");
				die;
			break;
		}

    ?>