class SuggestionSerializer
	include FastJsonapi::ObjectSerializer
	attributes :id, :suggestions
end