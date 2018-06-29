xquery version "3.1";
import module namespace functx = "http://www.functx.com" at "functx.xquery";

<em>
{
	<liste-pays>
	{
		let $doc := doc("mondial.xml")
        for $country 
        in $doc/mondial/country[/mondial/river[./to/@watertype eq "sea"]/tokenize(@country, " ") = @car_code  
            or /mondial/sea/tokenize(@country, " ") =  @car_code]
		return 
			<pays id-p="{$country/@car_code}" nom-p="{data($country/name)}" superficie="{$country/@area}" nbhab="{data($country/population[last()])}">
			{
				for $river in $doc/mondial/river[./to/@watertype = "sea"]
				where functx:is-value-in-sequence($country/@car_code, tokenize($river/@country, " ")) 
				    and $river/to/@watertype = "sea"
				return 
    				<fleuve id-f="{$river/@id}" nom-f="{data($river/name)}" longueur="{data($river/length)}" se-jette="{$river/to/@water}">
    				{
    					for $travel in tokenize($river/@country, " ")
    					return 
    						if (count(tokenize($river/@country, " ")) = 1) then 
    						  <parcourt id-pays = "{$travel}" distance = "{$river/length}"/>
    						else 
    						  <parcourt id-pays = "{$travel}"  distance = "inconnue"/>
    				}
    				</fleuve>
			}
			</pays>
	}
	</liste-pays>,
	<liste-espace-maritime>
	{
	   let $doc := doc("mondial.xml")
	   for $sea 
	   in $doc/mondial/sea
	   return 
			<espace-maritime id-e="{$sea/@id}" nom-e="{data($sea/name)}" type="inconnu">
			{
				for $coast 
				in tokenize($sea/@country, " ")
				return 
					<cotoie id-p="{$coast}"></cotoie>
			}
			</espace-maritime>
	}
	</liste-espace-maritime>
}
</em>
