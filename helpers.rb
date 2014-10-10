helpers do
  def doc_by_name doc_name
    settings.docs.find_one(name: doc_name).to_json
  end

  def doc_source doc_name
    JSON.parse(doc_by_name(doc_name))['source']
  end
end
