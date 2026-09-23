mkdir -p ../Arena_Boss

for i in 1 2 3 4 5
do
#touch ../Arena_Boss/"file$i.txt"
# Create the file if it doesn't exist,
# or empty it if it already exists
> ../Arena_Boss/"file$i.txt"

counter=0
target=$(((RANDOM % 11) +10))

while [ $counter -lt $target ]
do
echo "Filler" >>  ../Arena_Boss/"file$i.txt"
((counter++))
#echo "$counter"
done
done

Vadd=$(((RANDOM % 5) +1))
echo "Victory" >> ../Arena_Boss/"file$Vadd.txt"

echo "Smallest to Biggest:", $(ls -Shr ../Arena_Boss/)

mkdir -p Victory_Archive 
Winner=$(grep -l "Victory" ../Arena_Boss/*.txt)
mv "$Winner" Victory_Archive