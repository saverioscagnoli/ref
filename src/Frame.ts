interface FrameProps {
  x: number;
  y: number;
  img: HTMLImageElement;
}

export class Frame {
  private static readonly OFFSET = 5;
  public x: number;
  public y: number;
  public img: HTMLImageElement;

  public constructor({ x, y, img }: FrameProps) {
    this.x = x;
    this.y = y;
    this.img = img;
  }

  public collides(x: number, y: number): boolean {
    return (
      x >= this.x &&
      x <= this.x + this.img.width &&
      y >= this.y &&
      y <= this.y + this.img.height
    );
  }

  private drawBorder(ctx: CanvasRenderingContext2D): void {
    ctx.strokeStyle = "#ab20fd";
    ctx.lineWidth = 2;
    ctx.strokeRect(
      this.x - Frame.OFFSET,
      this.y - Frame.OFFSET,
      this.img.width + Frame.OFFSET * 2,
      this.img.height + Frame.OFFSET * 2
    );
  }

  public draw(ctx: CanvasRenderingContext2D): void {
    ctx.drawImage(this.img, this.x, this.y, this.img.width, this.img.height);
    this.drawBorder(ctx);
  }
}
