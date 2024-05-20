FROM denoland/deno:1.43.5

WORKDIR config

COPY . .

CMD ["bash"]
