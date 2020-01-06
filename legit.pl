#!/usr/bin/perl -w

##################################
# COMP 9041 Assignment 1 - Legit #
# Student : Bohan Zhao           #
# Zid : z5141730                 #
##################################
use File::Copy::Recursive qw(dircopy);
use File::Copy;
use File::Compare;
use File::Path 'remove_tree';
use Cwd;

main();

# Main function
sub main{
	my @argv = @ARGV;

    # have the standard input
	if(@argv != 0){

        # The initial funtion
		if($argv[0] eq "init"){
			# if @argv == 1, it only have one input 'init'.
			if(@argv == 1){
				init();
			}
			else{
				die "legit.pl: error: redundant or less arguments\n";
			}
		}

        # The add funtion
	    elsif($argv[0] eq "add"){
	    	# if @argv == 1, it is not include any file name.
	    	if(@argv == 1){
	    		die "legit.pl: error: no file name exist\n";
	    	}
	    	else{
	    		# Indentify name vaild or not of every files.
	    		foreach my $file(@argv[1..$#argv]){
					if($file =~ /^[\.|\/]/){
						die "legit.pl: error: invalid filename '$file'\n";
					}
					elsif($file =~ /^-/){
						die "legit.pl: error: legit.pl <filenames>\n";
					}
	    	    }
	    	    # Turn to the array which begin with file.
	    	    shift @argv;
		        add(@argv);
	        }
	    }

	    # The remove function
	    elsif($argv[0] eq "rm"){
	    	# if @argv == 1, it is not include any file name.
	    	if(@argv == 1){
	    		die "legit.pl: error: no file name exist\n";
	    	}

	    	# the condition of 'rm filename'.
	    	elsif($argv[1] ne "--force" && $argv[1] ne "--cached"){
	    		# Indentify name vaild or not of every files.
	    		foreach my $file(@argv[1..$#argv]){
					if($file =~ /^[\.|\/]/){
						die "legit.pl: error: invalid filename '$file'\n";
					}
					elsif($file =~ /^-/){
						die "legit.pl: error: legit.pl <filenames>\n";
					}
					elsif(!(-f $file)){
						die "legit.pl: error: can not open '$file'\n";
	    	        }
	    	    }
	    	    # Turn to the array which begin with file.
	    	    shift @argv;
		        rm_normal(@argv);	    		
	    	}

            # the condition of 'rm --force filename'.
	    	elsif($argv[1] eq "--force" && $argv[2] ne "--cached"){
	    		# Indentify name vaild or not of every files.
	    		foreach my $file(@argv[2..$#argv]){
					if($file =~ /^[\.|\/]/){
						die "legit.pl: error: invalid filename '$file'\n";
					}
					elsif($file =~ /^-/){
						die "legit.pl: error: legit.pl <filenames>\n";
					}
					elsif(!(-f $file)){
						die "legit.pl: error: can not open '$file'\n";
	    	        }
	    	    }
	    	    # Turn to the array which begin with file.
	    	    shift @argv;
	    	    shift @argv;
		        rm_force(@argv);
	    	}

            # the condition of 'rm --cached filename'.
	    	elsif($argv[1] eq "--cached" && $argv[2] ne "--force"){
	    		# Indentify name vaild or not of every files.
	    		foreach my $file(@argv[2..$#argv]){
					if($file =~ /^[\.|\/]/){
						die "legit.pl: error: invalid filename '$file'\n";
					}
					elsif($file =~ /^-/){
						die "legit.pl: error: legit.pl <filenames>\n";
					}
					elsif(!(-f $file)){
						die "legit.pl: error: can not open '$file'\n";
	    	        }
	    	    }
	    	    # Turn to the array which begin with file.
	    	    shift @argv;
	    	    shift @argv;
		        rm_cached(@argv);
		    }

            # the condition of 'rm --cached -- force filename' or 'rm -- force --cached filename'.
	    	elsif(($argv[1] eq "--cached" && $argv[2] eq "--force") ||
	    		($argv[2] eq "--cached" && $argv[1] eq "--force")){
	    		# Indentify name vaild or not of every files.
	    		foreach my $file(@argv[3..$#argv]){
					if($file =~ /^[\.|\/]/){
						die "legit.pl: error: invalid filename '$file'\n";
					}
					elsif($file =~ /^-/){
						die "legit.pl: error: legit.pl <filenames>\n";
					}
					elsif(!(-f $file)){
						die "legit.pl: error: can not open '$file'\n";
	    	        }
	    	    }
	    	    # Turn to the array which begin with file.
	    	    shift @argv;
	    	    shift @argv;
	    	    shift @argv;
		        rm_all(@argv);
	    	}
	    }

        # The commit function
	    elsif($argv[0] eq "commit" && $argv[1] eq "-m"){
	    	# if @argv != 3, it is not include any message.
	    	if(@argv != 3){
	    		die "legit.pl: error: Input error, no or more message\n";
	    	}    	
	    	$message = $argv[2];
	    	commit($message);
	    }

        # The commit and add function
	    elsif($argv[0] eq "commit" && $argv[1] eq "-a" && $argv[2] eq "-m" ){
	    	# if @argv != 3, it is not include any message.
	    	if(@argv != 4){
	    		die "legit.pl: error: Input error, no or more message\n";
	    	}   

	    	$message = $argv[2];
	    	commitadd($message); 	
	    }

	    # The log function
	    elsif($argv[0] eq "log"){
	    	if(!(-d ".legit")){
		       die "legit.pl: error: No .legit directory containing legit repository exists\n";
	        }
	        # if @argv != 1, it is include any redundants.
	    	if(@argv != 1){
	    		die "legit.pl: error: Redundant or less arguments\n";
	    	}

            # Open log.txt and print.
	    	chdir ".legit";
	    	open FILE,"<log.txt";
	    	@arr = ();
	    	$count = 0;

	    	while($line = <FILE>){
	    		$arr[$count] = $line;
	    		$count ++;
	    	}
	    	print reverse @arr;
	    	close FILE;
	    }

	    # The show function
	    elsif($argv[0] eq "show"){
	    	# if @argv != 2, it is include any redundants.
	    	if(@argv != 2){
	    		die "legit.pl: error: Redundant or less arguments\n";
	    	}
	    	# Indentify the foramt is correct.
	    	elsif(!($argv[1] =~ m/^.*[:]{1}.+$/)){
	    		die "legit.pl: error: Error input format\n";
	    	}

	    	@words = split /:/, $argv[1];
	    	show(@words);
	    }

	    # The status function
	    elsif($argv[0] eq "status"){
	    	# if @argv != 1, it is include any redundants.
	    	if(@argv != 1){
	    		die "legit.pl: error: Redundant or less arguments\n";
	    	}
	    	status();
	    }

	    # The branch function
	    elsif($argv[0] eq "branch"){
	    	# Show branch
	    	if(@argv == 1){
	    		branch_show();
	    	}
	    	# Delete branch
	        elsif(@argv == 3 && $argv[1] eq "-d"){
	        	# Indentify name vaild or not of every branch.
	        	if($argv[2] =~ /^[\.|\/]/){
	        		die "legit.pl: error: invalid branchname '$argv[2]'\n";
				}
				elsif($argv[2] =~ /^-/){
					die "legit.pl: error: legit.pl <branchnames>\n";
				}
				$branch = $argv[2];
				branch_delete($branch);
	    	}
	    	# Add branch
	    	elsif(@argv == 2){
	    		# Indentify name vaild or not of every branch.
	        	if($argv[1] =~ /^[\.|\/]/){
	        		die "legit.pl: error: invalid branchname '$argv[1]'\n";
				}
				elsif($argv[1] =~ /^-/){
					die "legit.pl: error: legit.pl <branchnames>\n";
				}
				$branch = $argv[1];
				branch_add($branch);
	    	}
	    	# It is include any redundants.
	    	else{
	    		die "legit.pl: error: Redundant or less arguments\n";
	    	}
	    }

	    # The checkout function
	    elsif($argv[0] eq 'checkout'){
	    	# if @argv != 2, it is include any redundants.
	    	if(@argv != 2){
	    		die "legit.pl: error: Redundant or less arguments\n";
	    	}
	    	elsif($argv[1] =~ /^[\.|\/]/){
	    		die "legit.pl: error: invalid branchname '$argv[1]'\n";
			}
			elsif($argv[1] =~ /^-/){
				die "legit.pl: error: legit.pl <branchnames>\n";
			}
			$branch = $argv[1];
			checkout($branch);
	    }

        # The merge function (not yet complete)
	    elsif($argv[0] eq 'merge'){
	    	last;
	    }

        # Error 
	    else{
	    	die "legit.pl: error: Error input, no order founded\n";
	    }
	}	    
 
    # if @argv == 0, nothing input.
	else{
		die "legit.pl: error: Nothing input\n";
	}

	exit 0;
}



# Inital function
sub init{
	if(-d ".legit"){
		die "legit.pl: error: .legit already exists\n";
	} 
	else{
		# Creat dir'.legit' and go to.
        mkdir ".legit";
        chdir ".legit";

        # Creat dir'index' branch'master'.
        # Creat dir'current' used to save some files and imformation for all branchs.
        mkdir "index";
        mkdir "master";
        mkdir "current";
        # Creat file'log.txt'.
        open FILE,">log.txt";
        close FILE;
        # Creat file'commit.txt' to save the number of current commit.
        open COMMIT,">commit.txt";
        print COMMIT "0";
        close COMMIT;
        # Creat file'branch.txt' to save the name of main branch of current stage.
        open BRANCH,">branch.txt";
        close BRANCH;
        open MAIN,">main.txt";
        print MAIN "master";
        close MAIN;
        chdir "current";
        # Creat dir'master' in dir'current'.
        # Creat dir'index''commit' in dir'master' to save the information for master.
        mkdir "master";
        mkdir "master/index";
        mkdir "master/commit";
        chdir "master";
        # Creat file'log.txt' in dir'master' to save the log information for master.
        open FILE,">log.txt";
        close FILE;

        print "Initialized empty legit repository in .legit\n";
	}
}



# Add function
sub add{
	my @files = @_;

	if(!(-d ".legit")){
		die "legit.pl: error: no .legit directory containing legit repository exists\n";
	}

	foreach my $file(@files){
		if(!(-f $file)){
			# If file not exist in workpath but exist in index, delete it in index.
			if(-f ".legit/index/$file"){
				unlink ".legit/index/$file";
			}
			else{
				die "legit.pl: error: can not open '$file'\n";
			}
	    }
	    # Copy file from workpath to index. 
	    else{
	    	copy($file, ".legit/index/$file");
	    }
	}
}



# Remove_normal function
sub rm_normal{
	my @files = @_;
	# Get the workpath.
	$path = getcwd();

	if(!(-d ".legit")){
		die "legit.pl: error: no .legit directory containing legit repository exists\n";
	}

	chdir ".legit";

    # Get the current main branch from 'main.txt'.
	open MAIN,"<main.txt";
	$main = <MAIN>;
	$main =~ s/[\n\r]//g;
	close MAIN;

    # Get the current commit number from 'current.txt'.
    @count_commit = glob("$main/*");
    $num = 0;
    $num_count = 0;

    # Get the current commit number of this branch.
	while(1){
		if(-d "$main/$num"){
			$num_count ++;
		}
		if($num_count == @count_commit){
			last;
		}
		$num ++;
	}

	# Make a compare to indentify wehther can be deleted or not.
	foreach my $file(@files){
		if (!(-f "index/$file")){
			die "legit.pl: error: '$file' is not in the legit repository\n";
		}
		elsif (!(-f "$path/$file")){
			die "legit.pl: error: '$file' is not in the legit repository\n";
		}
		elsif ((compare("$path/$file","index/$file") != 0) && (compare("index/$file","$main/$num/$file") == 0)){
			die "legit.pl: error: '$file' in repository is different to working file\n";
		}
		elsif ((compare("$path/$file","index/$file") == 0) && (compare("index/$file","$main/$num/$file") != 0)){
			die "legit.pl: error: '$file' has changes staged in the index\n";
		}
		elsif ((compare("$path/$file","index/$file") != 0) && (compare("index/$file","$main/$num/$file") != 0)){
			die "legit.pl: error: '$file' in index is different to both working file and repository\n";
		}
	}

    # Remove files.
	foreach my $file(@files){
		unlink "$path/$file";
		unlink "index/$file";
	}
}



# Remove_force function
sub rm_force{
	my @files = @_;
	# Get the workpath.
	$path = getcwd();

	if(!(-d ".legit")){
		die "legit.pl: error: no .legit directory containing legit repository exists\n";
	}

	chdir ".legit";

    # Get the current main branch from 'main.txt'.
	open MAIN,"<main.txt";
	$main = <MAIN>;
	$main =~ s/[\n\r]//g;
	close MAIN;

    # Get the current commit number from 'current.txt'.
    @count_commit = glob("$main/*");
    $num = 0;
    $num_count = 0;
 
    # Get the current commit number of this branch.
	while(1){
		if(-d "$main/$num"){
			$num_count ++;
		}
		if($num_count == @count_commit){
			last;
		}
		$num ++;
	}

   	# Make a compare to indentify wehther can be deleted or not.
	foreach my $file(@files){
		if (!(-f "index/$file")){
			die "legit.pl: error: '$file' is not in the legit repository\n";
		}
		elsif (!(-f "$path/$file")){
			die "legit.pl: error: '$file' is not in the legit repository\n";
		}
	}

    # Remove files.
	foreach my $file(@files){
		unlink "$path/$file";
		unlink "index/$file";
	}
}



# Remove_cached function
sub rm_cached{
	my @files = @_;
	# Get the workpath.
	$path = getcwd();

	if(!(-d ".legit")){
		die "legit.pl: error: no .legit directory containing legit repository exists\n";
	}

	chdir ".legit";

    # Get the current main branch from 'main.txt'.
	open MAIN,"<main.txt";
	$main = <MAIN>;
	$main =~ s/[\n\r]//g;
	close MAIN;

    # Get the current commit number from 'current.txt'.
    @count_commit = glob("$main/*");
    $num = 0;
    $num_count = 0;

    # Get the current commit number of this branch.
	while(1){
		if(-d "$main/$num"){
			$num_count ++;
		}
		if($num_count == @count_commit){
			last;
		}
		$num ++;
	}

    # Make a compare to indentify wehther can be deleted or not.
	foreach my $file(@files){
		if (!(-f "index/$file")){
			die "legit.pl: error: '$file' is not in the legit repository\n";
		}
		elsif (!(-f "$main/$num/$file")){
			if(!(-f "$path/$file")){
				die "legit.pl: error: '$file' is not in the legit repository\n";
			}
		}
		elsif ((compare("$path/$file","index/$file") != 0) && (compare("index/$file","$main/$num/$file") != 0)){
			die "legit.pl: error: '$file' in index is different to both working file and repository\n";
		}
	}

    # Remove files.
	foreach my $file(@files){
		unlink "index/$file";
	}
}



# Remove_all function
sub rm_all{
	my @files = @_;
	# Get the workpath.
	$path = getcwd();

	if(!(-d ".legit")){
		die "legit.pl: error: no .legit directory containing legit repository exists\n";
	}

	chdir ".legit";

    # Get the current main branch from 'main.txt'.
	open MAIN,"<main.txt";
	$main = <MAIN>;
	$main =~ s/[\n\r]//g;
	close MAIN;

    # Get the current commit number from 'current.txt'.
    @count_commit = glob("$main/*");
    $num = 0;
    $num_count = 0;

    # Get the current commit number of this branch.
	while(1){
		if(-d "$main/$num"){
			$num_count ++;
		}
		if($num_count == @count_commit){
			last;
		}
		$num ++;
	}

    # Make a compare to indentify wehther can be deleted or not.
	foreach my $file(@files){
		if (!(-f "index/$file")){
			die "legit.pl: error: '$file' is not in the legit repository\n";
		}
	}

    # Remove files.
	foreach my $file(@files){
		unlink "index/$file";
	}
}



# Commit function
sub commit{
	if(!(-d ".legit")){
		die "legit.pl: error: no .legit directory containing legit repository exists\n";
	}
	
	chdir ".legit";
	@name = glob("index/*"); 

	# Get the current main branch from 'main.txt'.
	open $MAIN,"<main.txt";
	$main = <$MAIN>;
	$main =~ s/[\n\r]//g;
	close $MAIN;

    # Get the current commit number from 'current.txt'.
	open COMMIT,"<commit.txt";
	$count = <COMMIT>;
	$count = int($count);
    @count_commit = glob("$main/*");
    $num = 0;
    $num_count = 0;

    # Get the current commit number of this branch.
	while(1){
		if(-d "$main/$num"){
			$num_count ++;
		}
		if($num_count == @count_commit){
			last;
		}
		$num ++;
	}

    # To compare it need to be commited or not.
	if($count != 0){
		@name1 = glob("$main/$num/*");

		if(@name == @name1){
			$flag = 0;
			foreach my $file0(@name){
				$file1 = substr($file0,6,length($file0)-6);
				if(compare("$file0","$main/$num/$file1") != 0){
					$flag = 1;
				    last;
				}
			}
			if($flag == 0){
				die "nothing to commit\n";
			}
		}
	}

    # Update 'log.txt''commit.txt'.
	mkdir "$main/$count";
	open  FILE,">>log.txt";
	print FILE "$count $message\n";
	close FILE;

	foreach my $file(@name){
	    copy($file, "$main/$count");
	}
	print "Committed as commit $count\n";

    $count ++;
	open COMMIT,">commit.txt";
    print COMMIT "$count";
    close COMMIT;
}



#commitadd
sub commitadd{ 
	if(!(-d ".legit")){
		die "legit.pl: error: no .legit directory containing legit repository exists\n";
	}

	$path = getcwd();
	chdir ".legit";
	@name = glob("index/*"); 

	# Get the current main branch from 'main.txt'.
	open MAIN,"<main.txt";
	$main = <MAIN>;
	$main =~ s/[\n\r]//g;
	close MAIN;

	# Get the current commit number from 'current.txt'.
	open COMMIT,"<commit.txt";
	$count = <COMMIT>;
	$count = int($count);
    @count_commit = glob("$main/*");
    $num = 0;
    $num_count = 0;

    # Get the current commit number of this branch.
	while(1){
		if(-d "$main/$num"){
			$num_count ++;
		}
		if($num_count == @count_commit){
			last;
		}
		$num ++;
	}

    # same as the add function.
	foreach my $files0(@name){
		$files1 = substr($files0,6,length($files0)-6);
		copy("$path/$files1","$files0");
	}

    # To compare it need to be commited or not.
	if($count != 0){
		@name1 = glob("$main/$num/*");

		if(@name == @name1){
			$flag = 0;
			foreach my $file0(@name){
				$file1 = substr($file0,6,length($file0)-6);
				if(compare("$file0","$main/$num/$file1") != 0){
					$flag = 1;
				    last;
				}
			}
			if($flag == 0){
				die "nothing to commit\n";
			}
		}
	}

    # Update 'log.txt''commit.txt'.
	mkdir "$main/$count";
	open  FILE,">>log.txt";
	print FILE "$count $message\n";
	close FILE;

	foreach my $file(@name){
	    copy($file, "$main/$count");
	}
	print "Committed as commit $count\n";

    $count ++;
	open COMMIT,">commit.txt";
    print COMMIT "$count";
    close COMMIT;
}

# Show function
sub show{
	if(!(-d ".legit")){
		die "legit.pl: error: no .legit directory containing legit repository exists\n";
	}

    # The condition like 'show :num'.
	if(length($words[0]) == 0){
		chdir ".legit/index";
		open (FILE,"<$words[1]") or die "legit.pl: error: '$words[1]' not found in index\n";
	    
	    while($line = <FILE>){
	    	print "$line";
	    }
	    close FILE;
	    exit 0;
	}
	# The condition like 'show num1:num2'.
	else{
		chdir ".legit";
		open MAIN,"<main.txt";
	    $main = <MAIN>;
	    $main =~ s/[\n\r]//g;
	    close MAIN;
		chdir "$main/$words[0]" or die "legit.pl: error: unknown commit '$words[0]'\n";
		open (FILE,"<$words[1]") or die "legit.pl: error: '$words[1]' not found in commit $words[0]\n";

		while($line = <FILE>){
	    	print "$line";
	    }
	    close FILE;
	    exit 0;
	}
}



# Status function
sub status{
	$path = getcwd();
	if(!(-d ".legit")){
		die "legit.pl: error: no .legit directory containing legit repository exists\n";
	}

	@name1 = glob("*");
	chdir ".legit/index";
	@name2 = glob("*");
	chdir "$path/.legit";

    
	# Get the current main branch from 'main.txt'.
    open MAIN,"<main.txt";
	$main = <MAIN>;
	$main =~ s/[\n\r]//g;
	close MAIN;

    # Get the current commit number from 'current.txt'.
    @count_commit = glob("$main/*");
    $num = 0;
    $num_count = 0;

    # Get the current commit number of this branch.
	while(1){
		if(-d "$main/$num"){
			$num_count ++;
		}
		if($num_count == @count_commit){
			last;
		}
		$num ++;
	}
 
	chdir "$main/$num";
	@name3 = glob("*");
	chdir "$path";

    # Sort anb filter any file in 'workpath''index'and'commit'.
	@array = (@name1,@name2,@name3);
	my %hash;
	@array = grep { ++$hash{$_} < 2 } @array;
	@array = sort @array;

	foreach my $file(@array){
		if(-f "$file"){
			if(-f ".legit/index/$file"){
				if(-f ".legit/$main/$num/$file"){
					if(compare("$file",".legit/index/$file") != 0 && compare(".legit/index/$file",".legit/$main/$num/$file") != 0){
						print "$file - file changed, different changes staged for commit\n";
					}
					elsif(compare("$file",".legit/index/$file") == 0 && compare(".legit/index/$file",".legit/$main/$num/$file") != 0){
						print "$file - file changed, changes staged for commit\n";
					}
					elsif(compare("$file",".legit/index/$file") != 0 && compare(".legit/index/$file",".legit/$main/$num/$file") == 0){
						print "$file - file changed, changes not staged for commit\n";
					}
					elsif(compare("$file",".legit/index/$file") == 0 && compare(".legit/index/$file",".legit/$main/$num/$file") == 0){
						print "$file - same as repo\n";
					}
				}
				else{
					print "$file - added to index\n";
				}
			}
			else{
				print "$file - untracked\n";
			}
		}
		else{
			if(-f ".legit/index/$file"){
				if(-f ".legit/$main/$num/$file"){
					print "$file - file deleted\n";
				}
			}
			else{
				print "$file - deleted\n";
			}
		}
	}
}



# branch_show function
sub branch_show{
	if(!(-d ".legit")){
		die "legit.pl: error: no .legit directory containing legit repository exists\n";
	}

	chdir ".legit";

	@name = glob("master/*");
	if(@name == 0){
		die "legit.pl: error: your repository does not have any commits yet\n";

	}
	
	# print the information from 'branch.txt'.
	open BRANCH,"<branch.txt";
	while($line = <BRANCH>){
		print "$line";
	}
	print "master\n";
	close BRANCH;
}


# branch_delete function
sub branch_delete{
	if(!(-d ".legit")){
		die "legit.pl: error: no .legit directory containing legit repository exists\n";
	}

	chdir ".legit";

	if($branch eq "master"){
		die "legit.pl: error: can not delete branch 'master'\n";
	}

    # Get the current main branch from 'main.txt'.
	open MAIN,"<main.txt";
	$main = <MAIN>;
	$main =~ s/[\n\r]//g;
	close MAIN;
	if($branch eq $main){
		die "legit.pl: error: can not delete branch 'master'\n";
	}

    # Get the current commit number from 'current.txt'.
	@count_commit = glob("$branch/*");
    $num = 0;
    $num_count = 0;

    # Get the current commit number of this branch.
	while(1){
		if(-d "$branch/$num"){
			$num_count ++;
		}
		if($num_count == @count_commit){
			last;
		}
		$num ++;
	}

	@count_commit1 = glob("master/*");
    $num1 = 0;
    $num_count1 = 0;

    # Indentify the commit num of branch of current and need to be deleted.
	while(1){
		if(-d "master/$num1"){
			$num_count1 ++;
		}
		if($num_count1 == @count_commit1){
			last;
		}
		$num1 ++;
	}
 
	if($num > $num1){
		die "legit.pl: error: branch '$branch' has unmerged changes\n";
	}

    # Delete branch.
	if(-d "$branch"){
		remove_tree($branch);
		remove_tree("current/$branch");
		print "Deleted branch '$branch'\n";
	}
	else{
		die "legit.pl: error: branch '$branch' does not exist\n";
	}

    # Update information of branch.txt.
	open BRANCH,"<branch.txt";
	@branch_new = ();
	while($line = <BRANCH>){
		chomp $line;  
		if ($line ne $branch){     
			push @branch_new, "$line\n";    
		}
	}
	open BRANCH,">branch.txt";
	print BRANCH @branch_new;
	close BRANCH;
}



# Branch_add function
sub branch_add{
	$path = getcwd();

	if(!(-d ".legit")){
		die "legit.pl: error: no .legit directory containing legit repository exists\n";
	}

	chdir ".legit";

	if($branch eq "master"){
		die "legit.pl: error: branch 'master' already exists\n";
	}
	if(-d "$branch"){
		die"legit.pl: error: branch '$branch' already exists\n";
	}

	mkdir "$branch";

    # Get the current main branch from 'main.txt'.
	open MAIN,"<main.txt";
	$main = <MAIN>;
	$main =~ s/[\n\r]//g;
	close MAIN;

	dircopy($main, $branch);

	open BRANCH,">>branch.txt";
	print BRANCH "$branch\n"; 
	close BRANCH;

    # save the information to current/branch
	chdir "$path";
	@name = glob("$path/*");
	@name1 = glob("$path/.legit/index/*");
	mkdir ".legit/current/$branch";
	mkdir ".legit/current/$branch/commit";
	mkdir ".legit/current/$branch/index";

	copy(".legit/log.txt",".legit/current/$branch");


	foreach my $file(@name){
		copy($file,".legit/current/$branch/commit");
	}

	foreach my $file1(@name1){
		copy($file1,".legit/current/$branch/index");
	}
}


# Checkout function
sub checkout{
	$path = getcwd();

	if(!(-d ".legit")){
		die "legit.pl: error: no .legit directory containing legit repository exists\n";
	}

	chdir ".legit";

	if(!(-d "$branch")){
		die "legit.pl: error: unknown branch '$branch'\n";
	}

    # Get the current main branch from 'main.txt'.
	open MAIN,"<main.txt";
	$main = <MAIN>;
	$main =~ s/[\n\r]//g;
	open MAIN,">main.txt";
    print MAIN "$branch";
    close MAIN;

    
    # Get the current commit number from 'current.txt'.
    @count_commit = glob("$main/*");
    $num = 0;
    $num_count = 0;

    # Get the current commit number of this branch.
	while(1){
		if(-d "$main/$num"){
			$num_count ++;
		}
		if($num_count == @count_commit){
			last;
		}
		$num ++;
	}
   
    chdir "$main/$num";
	@name0 = glob("*");
	@tmp = ();

    # Compare every file in workpath or commit or index.
	foreach my $file0(@name0){
		if((-f "$path/$file0") && (compare("$file0","$path/$file0") != 0))
		{
			push @tmp,"$file0";
		}
	}

	chdir "$path";

	@ss = glob("*");

	foreach my $ss(@ss){
		if((!(-f "$path/.legit/$main/$num/$ss")) && (!(-f "$path/.legit/index/$ss")))
		{
			push @tmp,"$ss";
		}
	}

    # According to different condition to decide file should be copy or not. 
    if(@tmp == 0){
    	@name = glob("$path/*");

    	foreach my $file(@name){
    		copy($file,".legit/current/$main/commit");
    		unlink($file);
    	}

    	@name1 = glob(".legit/current/$branch/commit/*");

    	foreach my $file1(@name1){
    		copy($file1,$path);
    	}
    }

    else{
    	@name = glob("*");

    	foreach my $file(@name){
    		$flag = 0;
    		foreach my $tmp(@tmp){
    			if("$tmp" eq "$file"){
    				$flag = 1; 
    			}
    		}
    		if($flag == 0){
    			copy($file,".legit/current/$main/commit");
    			unlink($file);
    		}
    	}

    	@name1 = glob(".legit/current/$branch/commit/*");

    	foreach my $file1(@name1){
    		$flag = 0;
    		foreach my $tmp(@tmp){
    			if(".legit/current/$branch/commit/$tmp" eq "$file1"){
    				$flag = 1; 
    			}
    		}
    		if($flag == 0){
    			copy($file1,$path);
    		}
    	}
    }


    if(@tmp == 0){
    	@index = glob("$path/.legit/index/*");

    	foreach my $index(@index){
    		copy($index,".legit/current/$main/index");
    		unlink($index);
    	}

    	@index1 = glob(".legit/current/$branch/index/*");

    	foreach my $index1(@index1){
    		copy($index1,"$path/.legit/index");
    	}
    }

    else{
    	@index = glob("$path/.legit/index/*");

    	foreach my $index(@index){
    		$flag = 0;
    		foreach my $tmp(@tmp){
    			if("$path/.legit/index/$tmp" eq "$index"){
    				$flag = 1; 
    			}
    		}
    		if($flag == 0){
    			copy($index,".legit/current/$main/index");
    		    unlink($index);
    		}
    	}

    	@index1 = glob(".legit/current/$branch/index/*");

    	foreach my $index1(@index1){
    		$flag = 0;
    		foreach my $tmp(@tmp){
    			if(".legit/current/$branch/index/$tmp" eq "$index1"){
    				$flag = 1; 
    			}
    		if($flag == 0){
    			copy($index1,"$path/.legit/index");
    		}
    		}
    	}
    }

    copy(".legit/log.txt",".legit/current/$main");
    unlink(".legit/log.txt");
    copy(".legit/current/$branch/log.txt",".legit");

	print "Switched to branch '$branch'\n";
}









	


