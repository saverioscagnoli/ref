import { Frame } from "./Frame";
import "./style.css";

document.querySelector<HTMLDivElement>("#app")!.innerHTML = `
  <canvas></canvas>
`;

let dragged: Frame | null = null;

const frames: Frame[] = [];

let [mX, mY] = [0, 0];

const canvas = document.querySelector("canvas")!;
const ctx = canvas.getContext("2d")!;


canvas.width = window.innerWidth;
canvas.height = window.innerHeight;

document.addEventListener("resize", () => {
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
});

canvas.addEventListener("mousemove", e => {
  [mX, mY] = [e.clientX, e.clientY];
  if (!dragged) return;
  dragged.x = mX - dragged.img.width * 0.5;
  dragged.y = mY - dragged.img.height * 0.5;
});

canvas.addEventListener("mousedown", e => {
  for (let i = 0; i < frames.length; i++) {
    const frame = frames[i];
    if (frame.collides(e.clientX, e.clientY)) {
      dragged = frame;
      break;
    }
  }
});

canvas.addEventListener("mouseup", () => {
  if (dragged) dragged = null;
});

canvas.addEventListener("wheel", e => {
  for (let i = 0; i < frames.length; i++) {
    const frame = frames[i];
    if (frame.collides(e.clientX, e.clientY)) {
      let f = 1 + e.deltaY * 0.001;
      let [w, h] = [frame.img.width * f, frame.img.height * f];
      frame.img.width = w;
      frame.img.height = h;
      break;
    }
  }
});
canvas.addEventListener("dragover", e => e.preventDefault());

canvas.addEventListener("drop", e => {
  e.preventDefault();
  const file = e.dataTransfer!.files[0];
  const reader = new FileReader();
  reader.onload = () => {
    const img = new Image();
    console.log(img.width, img.height);
    img.onload = () => {
      let [x, y] = [e.clientX - img.width * 0.5, e.clientY - img.height * 0.5];
      frames.push(new Frame({ x, y, img }));
    };
    img.src = reader.result as string;
  };
  reader.readAsDataURL(file);
});

document.addEventListener("keydown", e => {
  if (["Delete", "Backspace"].includes(e.key)) {
    console.log("delete");
    for (let i = 0; i < frames.length; i++) {
      const frame = frames[i];
      if (frame.collides(mX, mY)) {
        frames.splice(i, 1);
        break;
      }
    }
  }
});

const anim = () => {
  requestAnimationFrame(anim);

  ctx.clearRect(0, 0, canvas.width, canvas.height);

  for (let i = 0; i < frames.length; i++) {
    frames[i].draw(ctx);
  }
};

anim();
