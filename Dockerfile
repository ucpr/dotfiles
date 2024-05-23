FROM denoland/deno:1.43.6

WORKDIR config

COPY . .

CMD ["bash"]
