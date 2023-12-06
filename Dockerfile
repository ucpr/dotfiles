FROM denoland/deno:1.38.5

WORKDIR config

COPY . .

CMD ["bash"]
