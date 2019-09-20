// eslint-disable-next-line no-unused-vars
class TennisBall {
  constructor(c) {
    this.c = c
  }

  //  All assumed to be in cm
  drawObject(height, width, depth) {
    if (!this.c) return

    if (!depth) depth = 0.1

    //  For the moment only draw 3d objects
    if (!height || !width || !depth) return

    //  Get the longest thing
    let maxLength = height
    if (width > maxLength) maxLength = width
    if (depth > maxLength) maxLength = depth

    const slopeOffsetPercent = 0.18 // The percent we move the line up
    const slopeOffset = this.c.height * slopeOffsetPercent
    let heightPercent = height / maxLength
    let widthPercent = width / maxLength
    let depthPercent = depth / maxLength
    const halfway = this.c.width / 2

    const heightLength = (this.c.height - (slopeOffset * 2)) * heightPercent
    const widthLength = halfway * widthPercent
    const depthLength = halfway * depthPercent

    //  Work out the y offset
    const topMostPoint = this.c.height - (slopeOffset * widthPercent) - heightLength - (slopeOffset * depthPercent)
    const yOffset = topMostPoint / -2

    //  Work out the x offset
    const leftMostPoint = halfway - widthLength
    const rightMostPoint = halfway + depthLength
    const xOffset = ((this.c.width - rightMostPoint) - (leftMostPoint)) / 2

    const ctx = this.c.getContext('2d')
    ctx.lineWidth = 4
    ctx.strokeStyle = 'rgb(0, 0, 0)'
    ctx.beginPath()
    //  left bottom
    ctx.moveTo(xOffset + halfway, this.c.height + yOffset)
    ctx.lineTo(xOffset + halfway - widthLength, this.c.height - (slopeOffset * widthPercent) + yOffset)
    ctx.lineTo(xOffset + halfway - widthLength, this.c.height - (slopeOffset * widthPercent) - heightLength + yOffset)
    ctx.lineTo(xOffset + halfway, this.c.height - heightLength + yOffset)
    ctx.lineTo(xOffset + halfway, this.c.height + yOffset)

    ctx.lineTo(xOffset + halfway + depthLength, this.c.height - (slopeOffset * depthPercent) + yOffset)
    ctx.lineTo(xOffset + halfway + depthLength, this.c.height - (slopeOffset * depthPercent) - heightLength + yOffset)
    ctx.lineTo(xOffset + halfway, this.c.height - heightLength + yOffset)

    ctx.moveTo(xOffset + halfway - widthLength, this.c.height - (slopeOffset * widthPercent) - heightLength + yOffset)
    ctx.lineTo(xOffset + halfway - widthLength + depthLength, this.c.height - (slopeOffset * widthPercent) - heightLength - (slopeOffset * depthPercent) + yOffset)
    ctx.lineTo(xOffset + halfway + depthLength, this.c.height - (slopeOffset * depthPercent) - heightLength + yOffset)

    ctx.stroke()

    //  We can work out how many pixel per cm, because we know the height length and the actual height (in cm)
    const pxPerCm = heightLength / height
    const tennisBallHeight = pxPerCm * 2.426 //  Tennis ball is 6.86cm in diameter

    //  Set your prefered colours here
    ctx.lineWidth = 3
    ctx.strokeStyle = 'rgb(255, 255, 255)'
    ctx.fillStyle = 'rgba(85,85,85,1)'

    //  Drawing the ball
    ctx.beginPath()
    ctx.arc(halfway * 0.8, this.c.height + yOffset - (tennisBallHeight / 2), tennisBallHeight / 2, 0, 2 * Math.PI)
    ctx.fill()
    ctx.stroke()

  }
}