module ApplicationHelper
    # Este helper define uma classe CSS com base na popularidade da tag
    def tag_cloud_class(count, max_count)
      # Calcula a popularidade como uma porcentagem
      percentage = (count.to_f / max_count.to_f) * 100
      
      case
      when percentage > 80
        'tag-largest' # 20% mais populares
      when percentage > 60
        'tag-large'
      when percentage > 40
        'tag-medium'
      when percentage > 20
        'tag-small'
      else
        'tag-smallest' # 20% menos populares
      end
    end
  end