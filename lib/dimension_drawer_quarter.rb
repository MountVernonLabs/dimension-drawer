
class DimensionDrawer

  def initialize(height, width, depth, view_width, view_height, options = {})
    @height = height
    @width = width
    @depth = depth
    @view_height = view_height
    @view_width = view_width
    @scale = options[:scale]
    @exclude_units = options[:exclude_units]
  end

  def cabinet_projection(angle = 45)

    margin = 20

    # This is an artificial number which approximates perspective.
    depth_scale = 0.5

    scaled_depth = @depth * depth_scale

    lines = []

    total_height = @height + height_given_angle_and_hyp(angle, scaled_depth)
    total_width = @width + width_given_angle_and_hyp(angle, scaled_depth) + 6.7

    height_scale = (@view_height - (margin * 2)) / total_height
    width_scale = (@view_width - (margin * 2)) / total_width

    calculated_scale = [height_scale, width_scale].min

    if @scale.is_a? Float
      scale = @scale
    elsif @scale.is_a? Array
      scale = @scale.sort.reverse.detect {|x| calculated_scale > x } || calculated_scale
    else
      scale = calculated_scale
    end

    # the front box
    lines << rect(
      margin,
      @view_height - (margin + (scale * @height)),
      scale * @width,
      scale * @height
    )

    # first diagonal line
    lines << line(
      margin,
      (@view_height - (margin + (scale * @height))),
      margin + width_given_angle_and_hyp(angle, scale * @depth * depth_scale),
      (@view_height - (margin + (scale * @height) + height_given_angle_and_hyp(angle, scale * scaled_depth)))
    )

    # second diagonal line
    lines << line(
      margin + (scale * @width),
      (@view_height - (margin + (scale * @height))),
      margin +  (scale * @width) + width_given_angle_and_hyp(angle, scale * scaled_depth),
      (@view_height - (margin + (scale * @height) + height_given_angle_and_hyp(angle, scale * scaled_depth)))
    )

    # third diagonal line
    lines << line(
      margin + (scale * @width),
      (@view_height - margin),
      margin +  (scale * @width) + width_given_angle_and_hyp(angle, scale * scaled_depth),
      (@view_height - (margin + height_given_angle_and_hyp(angle, scale * scaled_depth)))
    )

    # top line
    lines << line(
      margin + width_given_angle_and_hyp(angle, scale * scaled_depth),
      (@view_height - (margin + (scale * @height) + height_given_angle_and_hyp(angle, scale * scaled_depth))),
      margin + width_given_angle_and_hyp(angle, scale * scaled_depth) + (scale * @width),
      (@view_height - (margin + (scale * @height) + height_given_angle_and_hyp(angle, scale * scaled_depth))),
    )

    # right line
    lines << line(
      margin + width_given_angle_and_hyp(angle, scale * scaled_depth) + (scale * @width),
      (@view_height - (margin + (scale * @height) + height_given_angle_and_hyp(angle, scale * scaled_depth))),
      margin + width_given_angle_and_hyp(angle, scale * scaled_depth) + (scale * @width),
      (@view_height - margin - height_given_angle_and_hyp(angle, scale * scaled_depth))
    )

    unless @exclude_units

      # Width text
      lines << text(margin + (scale * @width) / 2, @view_height - margin - 4, measurement_label(@width), :middle)

      # Hight text
      lines << text(margin + (scale * @width) - 2, @view_height - margin - ((scale * @height) / 2), measurement_label(@height), :end)

      # Depth text
      lines << text(
        margin + (width_given_angle_and_hyp(angle, scale * scaled_depth) / 2) + 20,
        @view_height - margin -(scale * @height) - (height_given_angle_and_hyp(angle, scale * scaled_depth) / 2),
         measurement_label(@depth), :start)

    end

    "<svg viewbox=\"0 0 400 320\" class=\"dimension-view\">" +
      lines.join('') +
      tennis_ball(scale, margin + (scale * @width) + margin, @view_height - margin) +
    "</svg>"

  end

  private

  def measurement_label(cm)

    if cm < 1
      unit = 'mm'
      value = cm * 10
    elsif cm < 100
      unit = 'cm'
      value = cm
    else
      unit = 'm'
      value = cm / 100
    end

    value = "%g" % value.round(1)

    "#{value} #{unit}"
  end

  def width_given_angle_and_hyp(angle, hyp)
    radians = angle.to_f / 180 * Math::PI
    hyp.to_f * Math.cos(radians)
  end

  def height_given_angle_and_hyp(angle, hyp)
    radians = angle.to_f / 180 * Math::PI
    hyp.to_f * Math.sin(radians)
  end

  def longest_length
    [@height, @width, @depth].max
  end

  def tennis_ball(scale, x, y)

    tennis_ball_height = (2.426 * scale)

    transformed_scale = tennis_ball_height / 280

    "<g fill-rule=\"evenodd\" transform=\"translate(#{x},#{y - tennis_ball_height})\">
      <g class=\"tennis-ball\" transform=\"scale(#{transformed_scale},#{transformed_scale})\">
        <circle class=\"ball\" cx=\"140.5\" cy=\"140.5\" r=\"139.5\"></circle>
    </g></g>"
  end


  def line(x1, y1, x2, y2)
    "<line x1=\"#{x1}\" y1=\"#{y1}\" x2=\"#{x2}\" y2=\"#{y2}\" class=\"edge\"></line>"
  end


  def rect(x, y, width, height)
    "<rect x=\"#{x}\" y=\"#{y}\" width=\"#{width}\" height=\"#{height}\" class=\"edge\"></rect>"
  end

  def text(x, y, text_content, text_anchor)
    "<text x=\"#{x}\" y=\"#{y}\" text-anchor=\"#{text_anchor}\">#{text_content}</text>"
  end

end